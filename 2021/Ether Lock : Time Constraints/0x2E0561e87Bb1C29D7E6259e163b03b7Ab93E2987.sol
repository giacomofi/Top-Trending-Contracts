['// SPDX-License-Identifier: MIT\n', 'pragma solidity 0.7.6;\n', 'pragma abicoder v2;\n', '\n', 'import "./abstracts/ConfigurableRightsPool.sol";\n', 'import "./abstracts/CRPFactory.sol";\n', 'import "./abstracts/BRegistry.sol";\n', 'import "./abstracts/IERC20DecimalsExt.sol";\n', 'import "@openzeppelin/contracts/access/Ownable.sol";\n', '\n', 'import "./lib/BConst.sol";\n', '\n', '// LBPController is a contract that acts as a very limited deployer and controller of a Balancer CRP Liquidity Pool\n', '// The purpose it was created instead of just using DSProxy is to have a better control over the created pool, such as:\n', '// - All of the LBP Parameters are hardcoded into the contract, thus are independent from human or software errors\n', '// - Stop swapping immedialy at pool deployment, so nobody can swap until the StartBlock of the LBP\n', "// - Allow to enable swapping only at StartBlock of the LBP, by anyone (so we don't rely only on ourselves for starting the LBP - mitigates start delay because of network congestions)\n", '// - As the LBPController is the only controller of the CRP - all code here is set in stone - thus GradualWeights are called only once in constructor and cannot be altered afterwards, etc\n', '// - We have limited anyone to add or remove liquidity or tokens from the pool - even the owner.\n', '// - Although we have an escape-hatch to withdraw liquidity ("but it\'s also disabled while the pool is running" - TODO: we shall decide on escape-hatch behavior)\n', '// - After EndBlock - anyone can stop the pool and liquidate it - all the assets will be transferred to the LBP Owner\n', '// - Pool is liquidated by removing the tokens\n', '// - TODO: "BONUS: We have an integrated poker-miner, which will use arbitrage on the weight change, for the users to extract more tokens from the pool, which will also incentivise them to do Poking"\n', '\n', '/// @title LBP Controller\n', '/// @author oiler.network\n', '/// @notice Helper contract used to initialize and manage the Balancer LBP and its underlying contracts such as BPool and CRP\n', 'contract LBPController is BConst, Ownable {\n', '  /// @dev Enum-like constants used as array-indices for better readability\n', '  uint constant TokenIndex = 0; \n', '  uint constant CollateralIndex = 1;\n', '\n', '  /// @dev Number of different tokens used in the pool -> collateral and token\n', '  uint constant ConstituentsCount = 2;\n', '\n', "  /// @dev Balancer's Configurable Rights Pools Factory address\n", '  address public CRPFactoryAddress;\n', '\n', "  /// @dev Balancer's Registry address\n", '  address public BRegistryAddress;\n', '\n', '  /// @dev Balancer Pools Factory address\n', '  address public BFactoryAddress;\n', '\n', '  /// @dev Address of the token to be distributed during the LBP\n', '  address public tokenAddress;\n', '\n', '  /// @dev Address of the collateral token to be used during the LBP\n', '  address public collateralAddress;\n', '\n', '  uint public constant initialTokenAmount = 3_500_000;    // LBP initial token amount\n', '  uint public constant initialCollateralAmount = 800_000; // LBP initial collateral amount\n', '  uint public constant startTokenWeight = 36 * BONE;      // 90% LBP initial token weight\n', '  uint public constant startCollateralWeight = 4 * BONE;  // 10% LBP initial collateral weight\n', '  uint public constant endTokenWeight = 16 * BONE;        // 40% LBP end token weight\n', '  uint public constant endCollateralWeight = 24 * BONE;   // 60% LBP end collateral weight\n', "  uint public constant swapFee = 0.01 * 1e18;             // x% fee taken on BPool swaps - it is protecting the pool against the bot activity during the LBP. We can't use BONE here, cause this fractional multiplication is still treatened like an integer literal\n", '\n', '  uint immutable public startBlock; // LBP start block is when Gradual Weights start to shift and pool can be started\n', '  uint immutable public endBlock;   // LBP end block is when Gradual Weights shift stops and pool can be ended with funds withdrawal\n', '  uint public listed;               // Listed just returns 1 when the pool is listed in the BRegistry\n', '\n', '  // [multisig] ----owns----> [LBPCONTROLLER] ----controls----> [CRP] ----controls----> [BPOOL]\n', '  ConfigurableRightsPool public crp;\n', '  BPool public pool;\n', '\n', '  ConfigurableRightsPool.PoolParams public poolParams;\n', '  ConfigurableRightsPool.CrpParams public crpParams;\n', '  RightsManager.Rights public rights;\n', '\n', '\n', '  /**\n', '   * @param _CRPFactoryAddress - Balancer CRP Factory address\n', '   * @param _BRegistryAddress - Balancer registry address\n', '   * @param _BFactoryAddress - Balancer Pools Factory address\n', '   * @param _tokenAddress - Address of the token to be distributed during the LBP\n', '   * @param _collateralAddress - Collateral address\n', '   * @param _startBlock - LBP start block. NOTE: must be bigger than the block number in which the LBPController deployment tx will be included to the chain\n', '   * @param _endBlock - LBP end block. NOTE: LBP duration cannot be longer than 500k blocks (2-3 months)\n', '   * @param _owner - Address of the Multisig contract to become the owner of the LBP Controller\n', '   */\n', '  constructor (\n', '      address _CRPFactoryAddress,\n', '      address _BRegistryAddress,\n', '      address _BFactoryAddress,\n', '      address _tokenAddress,\n', '      address _collateralAddress,\n', '      uint _startBlock,\n', '      uint _endBlock,\n', '      address _owner\n', '    ) Ownable() // Owner - multisig address for LBP Management and retrieval of funds after the LBP ends\n', '  {\n', '    require(_startBlock > block.number, "LBPController: startBlock must be in the future");\n', '    require(_startBlock < _endBlock, "LBPController: endBlock must be greater than startBlock");\n', '    require(_endBlock < _startBlock + 500_000, "LBPController: endBlock is too far in the future");\n', '\n', '    Ownable.transferOwnership(_owner);\n', '    CRPFactoryAddress = _CRPFactoryAddress;\n', '    BRegistryAddress = _BRegistryAddress;\n', '    BFactoryAddress = _BFactoryAddress;\n', '    tokenAddress = _tokenAddress;\n', '    collateralAddress = _collateralAddress;\n', '\n', '    startBlock = _startBlock;\n', '    endBlock = _endBlock;\n', '\n', "    // We don't use SafeMath in this contract because the tokens are specified by us in constructor, and multiplications will not overflow\n", '    uint initialTokenAmountWei = (10**IERC20DecimalsExt(tokenAddress).decimals()) * initialTokenAmount;\n', '    uint initialCollateralAmountWei = (10**IERC20DecimalsExt(collateralAddress).decimals()) * initialCollateralAmount;\n', '    \n', '    address[] memory constituentTokens = new address[](ConstituentsCount);\n', '    constituentTokens[TokenIndex] = tokenAddress;\n', '    constituentTokens[CollateralIndex] = collateralAddress;\n', '\n', '    uint[] memory tokenBalances = new uint[](ConstituentsCount);\n', '    tokenBalances[TokenIndex] = initialTokenAmountWei;\n', '    tokenBalances[CollateralIndex] = initialCollateralAmountWei;\n', '\n', '    uint[] memory tokenWeights = new uint[](ConstituentsCount);\n', '    tokenWeights[TokenIndex] = startTokenWeight;\n', '    tokenWeights[CollateralIndex] = startCollateralWeight;\n', '    \n', '    poolParams = ConfigurableRightsPool.PoolParams(\n', '      "APWLBP",         // string poolTokenSymbol;\n', '      "APWineTokenLBP",  // string poolTokenName;\n', '      constituentTokens,// address[] constituentTokens;\n', '      tokenBalances,    // uint[] tokenBalances;\n', '      tokenWeights,     // uint[] tokenWeights;\n', '      swapFee           // uint swapFee;\n', '    );\n', '\n', '    crpParams = ConfigurableRightsPool.CrpParams(\n', '      100 * BONE,          // uint initialSupply - amount of LiquidityTokens the owner of the pool gets when creating pool\n', '      _endBlock - _startBlock - 1, // uint minimumWeightChangeBlockPeriod - (NOTE: this does not restrict poking interval) We lock the gradualUpdate time to be equal to the LBP length\n', "      _endBlock - _startBlock - 1  // uint addTokenTimeLockInBlocks - when adding a new token (we don't do it) after creation of the pool - there's a commit period before it appears. We limit it to LBP length\n", '    );\n', '\n', '    rights = RightsManager.Rights(\n', '      true, // bool canPauseSwapping; = true - so we can enable swapping only during the LBP event\n', '      false,// bool canChangeSwapFee; = false - we cannot change fees\n', '      true, // bool canChangeWeights; = true - to be able to do updateGradualWeights (and then poke)\n', "      true, // bool canAddRemoveTokens; = true - so we can remove tokens to kill the pool. It also allows adding tokens, but we don't have these functions\n", "      true, // bool canWhitelistLPs; = true - so nobody, even owner - cannot add more liquidity to the pool without whitelisting, and we don't have whitelisting functions - so Whitelist is always empty\n", '      false // bool canChangeCap; = false - not needed, as we protect that nobody can add Liquidity by using an empty and immutable Whitelisting above already\n', '    );\n', '  }\n', '\n', '  /// @notice Creates the CRP smart pool and initializes its parameters\n', '  /// @dev Needs owner to have approved the tokens and collateral before calling this (manually and externally)\n', '  /// @dev This LBPController becomes the Controller of the CRP and holds its liquidity tokens\n', '  /// @dev Most of the logic was taken from https://github.com/balancer-labs/bactions-proxy/blob/master/contracts/BActions.sol\n', '  function createSmartPool() external onlyOwner {\n', '    require(address(crp) == address(0), "LBPController.createSmartPool, pool already exists");\n', '    CRPFactory factory = CRPFactory(CRPFactoryAddress);\n', '\n', '    require(poolParams.constituentTokens.length == ConstituentsCount, "ERR_LENGTH_MISMATCH");\n', '    require(poolParams.tokenBalances.length == ConstituentsCount, "ERR_LENGTH_MISMATCH");\n', '    require(poolParams.tokenWeights.length == ConstituentsCount, "ERR_LENGTH_MISMATCH");\n', '\n', '    crp = factory.newCrp(BFactoryAddress, poolParams, rights);\n', '\n', '    // Pull the tokens and collateral from Owner and Approve them to CRP\n', '    IERC20 token = IERC20(poolParams.constituentTokens[TokenIndex]);\n', '    require(token.transferFrom(msg.sender, address(this), poolParams.tokenBalances[TokenIndex]), "ERR_TRANSFER_FAILED");\n', '    _safeApprove(token, address(crp), poolParams.tokenBalances[TokenIndex]);\n', '\n', '    IERC20 collateral = IERC20(poolParams.constituentTokens[CollateralIndex]);\n', '    require(collateral.transferFrom(msg.sender, address(this), poolParams.tokenBalances[CollateralIndex]), "ERR_TRANSFER_FAILED");\n', '    _safeApprove(collateral, address(crp), poolParams.tokenBalances[CollateralIndex]);\n', '\n', '    crp.createPool(\n', '      crpParams.initialSupply,\n', '      crpParams.minimumWeightChangeBlockPeriod,\n', '      crpParams.addTokenTimeLockInBlocks\n', '    );\n', '\n', '    pool = BPool(crp.bPool());\n', '\n', '    // Disable swapping. Can be enabled back only when LBP starts\n', '    crp.setPublicSwap(false);\n', '    \n', '    // Initialize Gradual Weights shift for the whole LBP duration\n', '    uint[] memory endWeights = new uint[](ConstituentsCount);\n', '    endWeights[TokenIndex] = endTokenWeight;\n', '    endWeights[CollateralIndex] = endCollateralWeight;\n', '    crp.updateWeightsGradually(endWeights, startBlock, endBlock);\n', '  }\n', '\n', '  /// @notice Registers the newly created BPool into the Balancer Registry, so it appears on Balancer app website\n', '  /// @dev Can only be called by the Owner after createSmartPool()\n', '  function registerPool() external onlyOwner {\n', '    require (address(pool) != address(0), "Pool doesn\'t exist yet");\n', '    require (listed == 0, "Pool already registered");\n', '    listed = BRegistry(BRegistryAddress).addPoolPair(address(pool), tokenAddress, collateralAddress);\n', '  }\n', '\n', '  /// @notice Starts the trading on the pool\n', '  /// @dev Can be called by anyone after LBP start block\n', '  function startPool() external {\n', '    require(block.number >= startBlock, "LBP didn\'t start yet");\n', '    require(block.number <= endBlock, "LBP already ended");\n', '    crp.setPublicSwap(true);\n', '  }\n', '  \n', '  /// @notice End the trading on the pool, destroys pool, and sends all funds to Owner\n', '  /// @notice Works only if LBPController has 100% of LP Pool Tokens in it,\n', '  /// @notice otherwise one of the removeToken() will lack them and revert the entire endPool() transaction\n', '  /// @dev Can be called by anyone after LBP end block\n', '  function endPool() external {\n', '    require(block.number > endBlock, "LBP didn\'t end yet");\n', '    crp.setPublicSwap(false);\n', '\n', '    // Destroy the pool by removing all tokens, and transfer the funds to Owner\n', '    crp.removeToken(collateralAddress);\n', '    crp.removeToken(tokenAddress);\n', '    IERC20 collateral = IERC20(collateralAddress);\n', '    IERC20 token = IERC20(tokenAddress);\n', '    uint collateralBalance = collateral.balanceOf(address(this));\n', '    uint tokenBalance = token.balanceOf(address(this));\n', '    collateral.transfer(owner(), collateralBalance);\n', '    token.transfer(owner(), tokenBalance);\n', '  }\n', '\n', '  /// @notice Escape Hatch - in case the Owner wants to withdraw Liquidity Tokens\n', '  /// @dev If we withdraw the LP Tokens - we cannot kill the pool with endPool() unless we put 100% of LP Tokens back.\n', '  /// @dev All the underlying assets of bPool can be withdrawn if you have LP Tokens - via exitPool() function of CRP.\n', '  /// @dev You cannot withdraw 100% of assets because of bPool MIN_BALANCE restriction (minimum balance of any token in bPool should be at least 1 000 000 wei).\n', '  /// @dev But you can withdraw 99.999% of assets (BONE*99999/1000) which leaves just 1 Collateral token and 17 Tokens in bPool if called before LBP has any trades.\n', '  /// @dev This escape hatch is deliberately not disabled during the LBP run (although we could) - just for the sake of our peace of mind - that we can withdraw anytime.\n', '  /// @dev If you do a withdrawal (partial or full) - you can still endPool() if you put all the remaining LP Token balance back to LBPController.\n', ' function withdrawLBPTokens() public onlyOwner {\n', '    uint amount = crp.balanceOf(address(this));\n', '    require(crp.transfer(msg.sender, amount), "ERR_TRANSFER_FAILED");\n', '  }\n', '\n', '  /// @notice Poke Weights must be called at regular intervals - so the LBP price gradually changes\n', '  /// @dev Can be called by anyone after LBP start block\n', '  /// @dev Just calling CRP function - for simpler FrontEnd access\n', '  function pokeWeights() external {\n', '    crp.pokeWeights();\n', '  }\n', '\n', '  /// @notice Get the current weights of the LBP\n', '  /// @return tokenWeight\n', '  /// @return collateralWeight\n', '  function getWeights() external view returns (uint tokenWeight, uint collateralWeight) {\n', '    tokenWeight = pool.getNormalizedWeight(tokenAddress);\n', '    collateralWeight = pool.getNormalizedWeight(collateralAddress);\n', '  }\n', '\n', '  // --- Internal ---\n', '\n', '  /// @notice Safe approval is needed for tokens that require prior reset to 0, before setting another approval\n', '  /// @dev Imported from https://github.com/balancer-labs/bactions-proxy/blob/master/contracts/BActions.sol\n', '  function _safeApprove(IERC20 token, address spender, uint amount) internal {\n', '    if (token.allowance(address(this), spender) > 0) {\n', '      token.approve(spender, 0);\n', '    }\n', '      token.approve(spender, amount);\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity 0.7.6;\n', 'pragma abicoder v2;\n', '\n', 'import "./AbstractPool.sol";\n', 'import "./BPool.sol";\n', 'import "./BFactory.sol";\n', '\n', 'abstract contract ConfigurableRightsPool is AbstractPool {\n', '  struct PoolParams {\n', '    string poolTokenSymbol;\n', '    string poolTokenName;\n', '    address[] constituentTokens;\n', '    uint[] tokenBalances;\n', '    uint[] tokenWeights;\n', '    uint swapFee;\n', '  }\n', '\n', '  struct CrpParams {\n', '    uint initialSupply;\n', '    uint minimumWeightChangeBlockPeriod;\n', '    uint addTokenTimeLockInBlocks;\n', '  }\n', '\n', '  struct GradualUpdateParams {\n', '    uint startBlock;\n', '    uint endBlock;\n', '    uint[] startWeights;\n', '    uint[] endWeights;\n', '  }\n', '\n', '  struct Rights {\n', '        bool canPauseSwapping;\n', '        bool canChangeSwapFee;\n', '        bool canChangeWeights;\n', '        bool canAddRemoveTokens;\n', '        bool canWhitelistLPs;\n', '        bool canChangeCap;\n', '  }\n', '\n', '  struct NewTokenParams {\n', '        address addr;\n', '        bool isCommitted;\n', '        uint commitBlock;\n', '        uint denorm;\n', '        uint balance;\n', '  }\n', '\n', '  function createPool(uint initialSupply, uint minimumWeightChangeBlockPeriod, uint addTokenTimeLockInBlocks) external virtual;\n', '  function createPool(uint initialSupply) external virtual;\n', '  function updateWeightsGradually(uint[] calldata newWeights, uint startBlock, uint endBlock) external virtual;\n', '  function removeToken(address token) external virtual;\n', '  function bPool() external view virtual returns (BPool);\n', '  function bFactory() external view virtual returns(BFactory);\n', '  function minimumWeightChangeBlockPeriod() external view virtual returns(uint);\n', '  function addTokenTimeLockInBlocks() external view virtual returns(uint);\n', '  function bspCap() external view virtual returns(uint);\n', '  function pokeWeights() external virtual;\n', '  function gradualUpdate() external view virtual returns(GradualUpdateParams memory);\n', '  function setCap(uint newCap) external virtual;\n', '  function updateWeight(address token, uint newWeight) external virtual;\n', '  function commitAddToken(address token, uint balance, uint denormalizedWeight) external virtual;\n', '  function applyAddToken() external virtual;\n', '  function joinPool(uint poolAmountOut, uint[] calldata maxAmountsIn) external virtual;\n', '  function joinswapExternAmountIn(address tokenIn, uint tokenAmountIn, uint minPoolAmountOut) external virtual;\n', '  function joinswapPoolAmountOut(address tokenIn, uint poolAmountOut, uint maxAmountIn) external virtual;\n', '  function exitswapPoolAmountIn(address tokenOut, uint poolAmountIn, uint minAmountOut) external virtual;\n', '  function exitswapExternAmountOut(address tokenOut, uint tokenAmountOut, uint maxPoolAmountIn) external virtual;\n', '  function whitelistLiquidityProvider(address provider) external virtual;\n', '  function removeWhitelistedLiquidityProvider(address provider) external virtual;\n', '  function mintPoolShareFromLib(uint amount) public virtual;\n', '  function pushPoolShareFromLib(address to, uint amount) public virtual;\n', '  function pullPoolShareFromLib(address from, uint amount) public virtual;\n', '  function burnPoolShareFromLib(uint amount) public virtual;\n', '  function rights() external view virtual returns(Rights memory);\n', '  function newToken() external view virtual returns(NewTokenParams memory);\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity 0.7.6;\n', 'pragma abicoder v2;\n', '\n', 'import "./ConfigurableRightsPool.sol";\n', 'import "../lib/RightsManager.sol";\n', '\n', '\n', 'abstract contract CRPFactory {\n', '  function newCrp(address factoryAddress, ConfigurableRightsPool.PoolParams calldata params, RightsManager.Rights calldata rights) external virtual returns (ConfigurableRightsPool);\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity 0.7.6;\n', '\n', 'abstract contract BRegistry {\n', '  /// @return listed is always 1 - Balancer guys said this return is not really used \n', '  function addPoolPair(address pool, address token1, address token2) external virtual returns(uint256 listed);\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity 0.7.6;\n', '\n', 'import "@openzeppelin/contracts/token/ERC20/IERC20.sol";\n', '\n', 'interface IERC20DecimalsExt is IERC20 {\n', '    function decimals() external view returns(uint8);\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.6.0 <0.8.0;\n', '\n', 'import "../utils/Context.sol";\n', '/**\n', ' * @dev Contract module which provides a basic access control mechanism, where\n', ' * there is an account (an owner) that can be granted exclusive access to\n', ' * specific functions.\n', ' *\n', ' * By default, the owner account will be the one that deploys the contract. This\n', ' * can later be changed with {transferOwnership}.\n', ' *\n', ' * This module is used through inheritance. It will make available the modifier\n', ' * `onlyOwner`, which can be applied to your functions to restrict their use to\n', ' * the owner.\n', ' */\n', 'abstract contract Ownable is Context {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '    constructor () internal {\n', '        address msgSender = _msgSender();\n', '        _owner = msgSender;\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view virtual returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(owner() == _msgSender(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Leaves the contract without owner. It will not be possible to call\n', '     * `onlyOwner` functions anymore. Can only be called by the current owner.\n', '     *\n', '     * NOTE: Renouncing ownership will leave the contract without an owner,\n', '     * thereby removing any functionality that is only available to the owner.\n', '     */\n', '    function renounceOwnership() public virtual onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address newOwner) public virtual onlyOwner {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: GPL-3.0-or-later\n', '// This program is free software: you can redistribute it and/or modify\n', '// it under the terms of the GNU General Public License as published by\n', '// the Free Software Foundation, either version 3 of the License, or\n', '// (at your option) any later version.\n', '\n', '// This program is distributed in the hope that it will be useful,\n', '// but WITHOUT ANY WARRANTY; without even the implied warranty of\n', '// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n', '// GNU General Public License for more details.\n', '\n', '// You should have received a copy of the GNU General Public License\n', '// along with this program.  If not, see <http://www.gnu.org/licenses/>.\n', '\n', 'pragma solidity 0.7.6;\n', '\n', 'import "./BColor.sol";\n', '\n', 'contract BConst is BBronze {\n', '    uint public constant BONE              = 10**18;\n', '\n', '    uint public constant MIN_BOUND_TOKENS  = 2;\n', '    uint public constant MAX_BOUND_TOKENS  = 8;\n', '\n', '    uint public constant MIN_FEE           = BONE / 10**6;\n', '    uint public constant MAX_FEE           = BONE / 10;\n', '    uint public constant EXIT_FEE          = 0;\n', '\n', '    uint public constant MIN_WEIGHT        = BONE;\n', '    uint public constant MAX_WEIGHT        = BONE * 50;\n', '    uint public constant MAX_TOTAL_WEIGHT  = BONE * 50;\n', '    uint public constant MIN_BALANCE       = BONE / 10**12;\n', '\n', '    uint public constant INIT_POOL_SUPPLY  = BONE * 100;\n', '\n', '    uint public constant MIN_BPOW_BASE     = 1 wei;\n', '    uint public constant MAX_BPOW_BASE     = (2 * BONE) - 1 wei;\n', '    uint public constant BPOW_PRECISION    = BONE / 10**10;\n', '\n', '    uint public constant MAX_IN_RATIO      = BONE / 2;\n', '    uint public constant MAX_OUT_RATIO     = (BONE / 3) + 1 wei;\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity 0.7.6;\n', '\n', 'import "./IERC20DecimalsExt.sol";\n', 'import "./BalancerOwnable.sol";\n', '\n', 'abstract contract AbstractPool is IERC20DecimalsExt, BalancerOwnable {\n', '  function setSwapFee(uint swapFee) external virtual;\n', '  function setPublicSwap(bool public_) external virtual;\n', '  function isPublicSwap() external virtual view returns (bool);\n', '  function exitPool(uint poolAmountIn, uint[] calldata minAmountsOut) external virtual;\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity 0.7.6;\n', '\n', 'import "./AbstractPool.sol";\n', '\n', 'abstract contract BPool is AbstractPool {\n', '  function finalize() external virtual;\n', '  function bind(address token, uint balance, uint denorm) external virtual;\n', '  function rebind(address token, uint balance, uint denorm) external virtual;\n', '  function unbind(address token) external virtual;\n', '  function isBound(address t) external view virtual returns (bool);\n', '  function getCurrentTokens() external view virtual returns (address[] memory);\n', '  function getFinalTokens() external view virtual returns(address[] memory);\n', '  function getBalance(address token) external view virtual returns (uint);\n', '  function getSpotPrice(address tokenIn, address tokenOut) external view virtual returns (uint spotPrice);\n', '  function getSpotPriceSansFee(address tokenIn, address tokenOut) external view virtual returns (uint spotPrice);\n', '  function getNormalizedWeight(address token) external view virtual returns (uint);\n', '  function isFinalized() external view virtual returns (bool);\n', '  function swapExactAmountIn(address tokenIn, uint tokenAmountIn, address tokenOut, uint minAmountOut, uint maxPrice) external virtual returns (uint tokenAmountOut, uint spotPriceAfter);\n', '  function joinPool(uint poolAmountOut, uint[] calldata maxAmountsIn) external virtual;\n', '  function swapExactAmountOut(address tokenIn, uint maxAmountIn, address tokenOut, uint tokenAmountOut, uint maxPrice) external virtual;\n', '  function joinswapExternAmountIn(address tokenIn, uint tokenAmountIn, uint minPoolAmountOut) external virtual;\n', '  function joinswapPoolAmountOut(address tokenIn, uint poolAmountOut, uint maxAmountIn) external virtual;\n', '  function exitswapPoolAmountIn(address tokenOut, uint poolAmountIn, uint minAmountOut) external virtual;\n', '  function exitswapExternAmountOut(address tokenOut, uint tokenAmountOut, uint maxPoolAmountIn) external virtual;\n', '  function getNumTokens() external virtual view returns(uint);\n', '  function getDenormalizedWeight(address token) external virtual view returns (uint);\n', '  function getSwapFee() external virtual view returns(uint);\n', '  function getController() external virtual view returns(address);\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity 0.7.6;\n', '\n', 'import "./BPool.sol";\n', '\n', 'abstract contract BFactory {\n', '  function newBPool() external virtual returns (BPool);\n', '    function setBLabs(address b) external virtual;\n', '    function collect(BPool pool) external virtual;\n', '    function isBPool(address b) external virtual view returns (bool);\n', '    function getBLabs() external virtual view returns (address);\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity 0.7.6;\n', '\n', 'abstract contract BalancerOwnable {\n', "  // We don't call it, but this contract is required in other inheritances\n", '  function setController(address controller) external virtual;\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.6.0 <0.8.0;\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity 0.7.6;\n', '\n', 'library RightsManager {\n', '  struct Rights {\n', '  bool canPauseSwapping;\n', '  bool canChangeSwapFee;\n', '  bool canChangeWeights;\n', '  bool canAddRemoveTokens;\n', '  bool canWhitelistLPs;\n', '  bool canChangeCap;\n', '  }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.6.0 <0.8.0;\n', '\n', '/*\n', ' * @dev Provides information about the current execution context, including the\n', ' * sender of the transaction and its data. While these are generally available\n', ' * via msg.sender and msg.data, they should not be accessed in such a direct\n', ' * manner, since when dealing with GSN meta-transactions the account sending and\n', ' * paying for execution may not be the actual sender (as far as an application\n', ' * is concerned).\n', ' *\n', ' * This contract is only required for intermediate, library-like contracts.\n', ' */\n', 'abstract contract Context {\n', '    function _msgSender() internal view virtual returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view virtual returns (bytes memory) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: GPL-3.0-or-later\n', '// This program is free software: you can redistribute it and/or modify\n', '// it under the terms of the GNU General Public License as published by\n', '// the Free Software Foundation, either version 3 of the License, or\n', '// (at your option) any later version.\n', '\n', '// This program is distributed in the hope that it will be useful,\n', '// but WITHOUT ANY WARRANTY; without even the implied warranty of\n', '// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n', '// GNU General Public License for more details.\n', '\n', '// You should have received a copy of the GNU General Public License\n', '// along with this program.  If not, see <http://www.gnu.org/licenses/>.\n', '\n', 'pragma solidity 0.7.6;\n', '\n', 'abstract contract BColor {\n', '    function getColor()\n', '        external view virtual\n', '        returns (bytes32);\n', '}\n', '\n', 'contract BBronze is BColor {\n', '    function getColor()\n', '        external pure override\n', '        returns (bytes32) {\n', '            return bytes32("BRONZE");\n', '        }\n', '}\n', '\n', '{\n', '  "optimizer": {\n', '    "enabled": true,\n', '    "runs": 1000\n', '  },\n', '  "outputSelection": {\n', '    "*": {\n', '      "*": [\n', '        "evm.bytecode",\n', '        "evm.deployedBytecode",\n', '        "abi"\n', '      ]\n', '    }\n', '  },\n', '  "libraries": {}\n', '}']