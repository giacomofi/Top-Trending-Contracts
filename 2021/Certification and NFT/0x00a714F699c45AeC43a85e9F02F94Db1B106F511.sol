['// SPDX-License-Identifier: MIT\n', 'pragma solidity 0.7.4;\n', 'import "@openzeppelin/contracts/access/Ownable.sol";\n', 'import "./IERC20.sol";\n', 'import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";\n', 'import "@uniswap/v2-periphery/contracts/interfaces/IWETH.sol";\n', 'import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol";\n', 'import "./IFeeDistributor.sol";\n', '\n', 'contract LiquidVault is Ownable {\n', '  /** Emitted when purchaseLP() is called to track ETH amounts */\n', '  event EthTransferred(\n', '      address from,\n', '      uint amount,\n', '      uint percentageAmount\n', '  );\n', '\n', '  /** Emitted when purchaseLP() is called and LP tokens minted */\n', '  event LPQueued(\n', '      address holder,\n', '      uint amount,\n', '      uint eth,\n', '      uint infinityToken,\n', '      uint timestamp\n', '  );\n', '\n', '  /** Emitted when claimLP() is called */\n', '  event LPClaimed(\n', '      address holder,\n', '      uint amount,\n', '      uint timestamp,\n', '      uint exitFee,\n', '      bool claimed\n', '  );\n', '\n', '  struct LPbatch {\n', '      address holder;\n', '      uint amount;\n', '      uint timestamp;\n', '      bool claimed;\n', '  }\n', '\n', '  struct LiquidVaultConfig {\n', '      address infinityToken;\n', '      IUniswapV2Router02 uniswapRouter;\n', '      IUniswapV2Pair tokenPair;\n', '      IFeeDistributor feeDistributor;\n', '      address weth;\n', '      address payable feeReceiver;\n', '      uint32 stakeDuration;\n', '      uint8 donationShare; //0-100\n', '      uint8 purchaseFee; //0-100\n', '  }\n', '  \n', '  bool public forceUnlock;\n', '  bool private locked;\n', '\n', '  modifier lock {\n', '      require(!locked, "LiquidVault: reentrancy violation");\n', '      locked = true;\n', '      _;\n', '      locked = false;\n', '  }\n', '\n', '  LiquidVaultConfig public config;\n', '\n', '  mapping(address => LPbatch[]) public lockedLP;\n', '  mapping(address => uint) public queueCounter;\n', '\n', '  function seed(\n', '      uint32 duration,\n', '      address infinityToken,\n', '      address uniswapPair,\n', '      address uniswapRouter,\n', '      address feeDistributor,\n', '      address payable feeReceiver,\n', '      uint8 donationShare, // LP Token\n', '      uint8 purchaseFee // ETH\n', '  ) public onlyOwner {\n', '      config.infinityToken = infinityToken;\n', '      config.uniswapRouter = IUniswapV2Router02(uniswapRouter);\n', '      config.tokenPair = IUniswapV2Pair(uniswapPair);\n', '      config.feeDistributor = IFeeDistributor(feeDistributor);\n', '      config.weth = config.uniswapRouter.WETH();\n', '      setFeeReceiverAddress(feeReceiver);\n', '      setParameters(duration, donationShare, purchaseFee);\n', '  }\n', '\n', '  function getStakeDuration() public view returns (uint) {\n', '      return forceUnlock ? 0 : config.stakeDuration;\n', '  }\n', '\n', '  // Could not be canceled if activated\n', '  function enableLPForceUnlock() public onlyOwner {\n', '      forceUnlock = true;\n', '  }\n', '\n', '  function setFeeReceiverAddress(address payable feeReceiver) public onlyOwner {\n', '      require(\n', '          feeReceiver != address(0),\n', '          "LiquidVault: ETH receiver is zero address"\n', '      );\n', '\n', '      config.feeReceiver = feeReceiver;\n', '  }\n', '\n', '  function setParameters(uint32 duration, uint8 donationShare, uint8 purchaseFee)\n', '      public\n', '      onlyOwner\n', '  {\n', '      require(\n', '          donationShare <= 100,\n', '          "LiquidVault: donation share % between 0 and 100"\n', '      );\n', '      require(\n', '          purchaseFee <= 100,\n', '          "LiquidVault: purchase fee share % between 0 and 100"\n', '      );\n', '\n', '      config.stakeDuration = duration * 1 days;\n', '      config.donationShare = donationShare;\n', '      config.purchaseFee = purchaseFee;\n', '  }\n', '\n', '  function purchaseLPFor(address beneficiary) public payable lock {\n', '      config.feeDistributor.distributeFees();\n', '      require(msg.value > 0, "LiquidVault: ETH required to mint INFINITY LP");\n', '\n', '      uint feeValue = (config.purchaseFee * msg.value) / 100;\n', '      uint exchangeValue = msg.value - feeValue;\n', '\n', '      (uint reserve1, uint reserve2, ) = config.tokenPair.getReserves();\n', '\n', '      uint infinityRequired;\n', '\n', '      if (address(config.infinityToken) < address(config.weth)) {\n', '          infinityRequired = config.uniswapRouter.quote(\n', '              exchangeValue,\n', '              reserve2,\n', '              reserve1\n', '          );\n', '      } else {\n', '          infinityRequired = config.uniswapRouter.quote(\n', '              exchangeValue,\n', '              reserve1,\n', '              reserve2\n', '          );\n', '      }\n', '\n', '      uint balance = IERC20(config.infinityToken).balanceOf(address(this));\n', '      require(\n', '          balance >= infinityRequired,\n', '          "LiquidVault: insufficient INFINITY tokens in LiquidVault"\n', '      );\n', '\n', '      IWETH(config.weth).deposit{ value: exchangeValue }();\n', '      address tokenPairAddress = address(config.tokenPair);\n', '      IWETH(config.weth).transfer(tokenPairAddress, exchangeValue);\n', '      IERC20(config.infinityToken).transfer(\n', '          tokenPairAddress,\n', '          infinityRequired\n', '      );\n', '\n', '      uint liquidityCreated = config.tokenPair.mint(address(this));\n', '      config.feeReceiver.transfer(feeValue);\n', '\n', '      lockedLP[beneficiary].push(\n', '          LPbatch({\n', '              holder: beneficiary,\n', '              amount: liquidityCreated,\n', '              timestamp: block.timestamp,\n', '              claimed: false\n', '          })\n', '      );\n', '\n', '      emit LPQueued(\n', '          beneficiary,\n', '          liquidityCreated,\n', '          exchangeValue,\n', '          infinityRequired,\n', '          block.timestamp\n', '      );\n', '\n', '      emit EthTransferred(msg.sender, exchangeValue, feeValue);\n', '  }\n', '\n', '  //send ETH to match with INFINITY tokens in LiquidVault\n', '  function purchaseLP() public payable {\n', '      purchaseLPFor(msg.sender);\n', '  }\n', '\n', '  function claimLP() public {\n', '      uint next = queueCounter[msg.sender];\n', '      require(\n', '          next < lockedLP[msg.sender].length,\n', '          "LiquidVault: nothing to claim."\n', '      );\n', '      LPbatch storage batch = lockedLP[msg.sender][next];\n', '      require(\n', '          block.timestamp - batch.timestamp > getStakeDuration(),\n', '          "LiquidVault: LP still locked."\n', '      );\n', '      next++;\n', '      queueCounter[msg.sender] = next;\n', '      uint donation = (config.donationShare * batch.amount) / 100;\n', '      batch.claimed = true;\n', '      emit LPClaimed(msg.sender, batch.amount, block.timestamp, donation, batch.claimed);\n', '      require(\n', '          config.tokenPair.transfer(address(0), donation),\n', '          "LiquidVault: donation transfer failed in LP claim."\n', '      );\n', '      require(\n', '          config.tokenPair.transfer(batch.holder, batch.amount - donation),\n', '          "LiquidVault: transfer failed in LP claim."\n', '      );\n', '  }\n', '\n', '  function lockedLPLength(address holder) public view returns (uint) {\n', '      return lockedLP[holder].length;\n', '  }\n', '\n', '  function getLockedLP(address holder, uint position)\n', '      public\n', '      view\n', '      returns (\n', '          address,\n', '          uint,\n', '          uint,\n', '          bool\n', '      )\n', '  {\n', '      LPbatch memory batch = lockedLP[holder][position];\n', '      return (batch.holder, batch.amount, batch.timestamp, batch.claimed);\n', '  }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.6.0 <0.8.0;\n', '\n', 'import "../utils/Context.sol";\n', '/**\n', ' * @dev Contract module which provides a basic access control mechanism, where\n', ' * there is an account (an owner) that can be granted exclusive access to\n', ' * specific functions.\n', ' *\n', ' * By default, the owner account will be the one that deploys the contract. This\n', ' * can later be changed with {transferOwnership}.\n', ' *\n', ' * This module is used through inheritance. It will make available the modifier\n', ' * `onlyOwner`, which can be applied to your functions to restrict their use to\n', ' * the owner.\n', ' */\n', 'abstract contract Ownable is Context {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '    constructor () internal {\n', '        address msgSender = _msgSender();\n', '        _owner = msgSender;\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view virtual returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(owner() == _msgSender(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Leaves the contract without owner. It will not be possible to call\n', '     * `onlyOwner` functions anymore. Can only be called by the current owner.\n', '     *\n', '     * NOTE: Renouncing ownership will leave the contract without an owner,\n', '     * thereby removing any functionality that is only available to the owner.\n', '     */\n', '    function renounceOwnership() public virtual onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address newOwner) public virtual onlyOwner {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', 'pragma solidity 0.7.4;\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'pragma solidity >=0.6.2;\n', '\n', "import './IUniswapV2Router01.sol';\n", '\n', 'interface IUniswapV2Router02 is IUniswapV2Router01 {\n', '    function removeLiquidityETHSupportingFeeOnTransferTokens(\n', '        address token,\n', '        uint liquidity,\n', '        uint amountTokenMin,\n', '        uint amountETHMin,\n', '        address to,\n', '        uint deadline\n', '    ) external returns (uint amountETH);\n', '    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(\n', '        address token,\n', '        uint liquidity,\n', '        uint amountTokenMin,\n', '        uint amountETHMin,\n', '        address to,\n', '        uint deadline,\n', '        bool approveMax, uint8 v, bytes32 r, bytes32 s\n', '    ) external returns (uint amountETH);\n', '\n', '    function swapExactTokensForTokensSupportingFeeOnTransferTokens(\n', '        uint amountIn,\n', '        uint amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint deadline\n', '    ) external;\n', '    function swapExactETHForTokensSupportingFeeOnTransferTokens(\n', '        uint amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint deadline\n', '    ) external payable;\n', '    function swapExactTokensForETHSupportingFeeOnTransferTokens(\n', '        uint amountIn,\n', '        uint amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint deadline\n', '    ) external;\n', '}\n', '\n', 'pragma solidity >=0.5.0;\n', '\n', 'interface IWETH {\n', '    function deposit() external payable;\n', '    function transfer(address to, uint value) external returns (bool);\n', '    function withdraw(uint) external;\n', '}\n', '\n', 'pragma solidity >=0.5.0;\n', '\n', 'interface IUniswapV2Pair {\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '\n', '    function name() external pure returns (string memory);\n', '    function symbol() external pure returns (string memory);\n', '    function decimals() external pure returns (uint8);\n', '    function totalSupply() external view returns (uint);\n', '    function balanceOf(address owner) external view returns (uint);\n', '    function allowance(address owner, address spender) external view returns (uint);\n', '\n', '    function approve(address spender, uint value) external returns (bool);\n', '    function transfer(address to, uint value) external returns (bool);\n', '    function transferFrom(address from, address to, uint value) external returns (bool);\n', '\n', '    function DOMAIN_SEPARATOR() external view returns (bytes32);\n', '    function PERMIT_TYPEHASH() external pure returns (bytes32);\n', '    function nonces(address owner) external view returns (uint);\n', '\n', '    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;\n', '\n', '    event Mint(address indexed sender, uint amount0, uint amount1);\n', '    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);\n', '    event Swap(\n', '        address indexed sender,\n', '        uint amount0In,\n', '        uint amount1In,\n', '        uint amount0Out,\n', '        uint amount1Out,\n', '        address indexed to\n', '    );\n', '    event Sync(uint112 reserve0, uint112 reserve1);\n', '\n', '    function MINIMUM_LIQUIDITY() external pure returns (uint);\n', '    function factory() external view returns (address);\n', '    function token0() external view returns (address);\n', '    function token1() external view returns (address);\n', '    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);\n', '    function price0CumulativeLast() external view returns (uint);\n', '    function price1CumulativeLast() external view returns (uint);\n', '    function kLast() external view returns (uint);\n', '\n', '    function mint(address to) external returns (uint liquidity);\n', '    function burn(address to) external returns (uint amount0, uint amount1);\n', '    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;\n', '    function skim(address to) external;\n', '    function sync() external;\n', '\n', '    function initialize(address, address) external;\n', '}\n', '\n', 'interface IFeeDistributor {\n', '  function distributeFees() external;\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.6.0 <0.8.0;\n', '\n', '/*\n', ' * @dev Provides information about the current execution context, including the\n', ' * sender of the transaction and its data. While these are generally available\n', ' * via msg.sender and msg.data, they should not be accessed in such a direct\n', ' * manner, since when dealing with GSN meta-transactions the account sending and\n', ' * paying for execution may not be the actual sender (as far as an application\n', ' * is concerned).\n', ' *\n', ' * This contract is only required for intermediate, library-like contracts.\n', ' */\n', 'abstract contract Context {\n', '    function _msgSender() internal view virtual returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view virtual returns (bytes memory) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', '\n', 'pragma solidity >=0.6.2;\n', '\n', 'interface IUniswapV2Router01 {\n', '    function factory() external pure returns (address);\n', '    function WETH() external pure returns (address);\n', '\n', '    function addLiquidity(\n', '        address tokenA,\n', '        address tokenB,\n', '        uint amountADesired,\n', '        uint amountBDesired,\n', '        uint amountAMin,\n', '        uint amountBMin,\n', '        address to,\n', '        uint deadline\n', '    ) external returns (uint amountA, uint amountB, uint liquidity);\n', '    function addLiquidityETH(\n', '        address token,\n', '        uint amountTokenDesired,\n', '        uint amountTokenMin,\n', '        uint amountETHMin,\n', '        address to,\n', '        uint deadline\n', '    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);\n', '    function removeLiquidity(\n', '        address tokenA,\n', '        address tokenB,\n', '        uint liquidity,\n', '        uint amountAMin,\n', '        uint amountBMin,\n', '        address to,\n', '        uint deadline\n', '    ) external returns (uint amountA, uint amountB);\n', '    function removeLiquidityETH(\n', '        address token,\n', '        uint liquidity,\n', '        uint amountTokenMin,\n', '        uint amountETHMin,\n', '        address to,\n', '        uint deadline\n', '    ) external returns (uint amountToken, uint amountETH);\n', '    function removeLiquidityWithPermit(\n', '        address tokenA,\n', '        address tokenB,\n', '        uint liquidity,\n', '        uint amountAMin,\n', '        uint amountBMin,\n', '        address to,\n', '        uint deadline,\n', '        bool approveMax, uint8 v, bytes32 r, bytes32 s\n', '    ) external returns (uint amountA, uint amountB);\n', '    function removeLiquidityETHWithPermit(\n', '        address token,\n', '        uint liquidity,\n', '        uint amountTokenMin,\n', '        uint amountETHMin,\n', '        address to,\n', '        uint deadline,\n', '        bool approveMax, uint8 v, bytes32 r, bytes32 s\n', '    ) external returns (uint amountToken, uint amountETH);\n', '    function swapExactTokensForTokens(\n', '        uint amountIn,\n', '        uint amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint deadline\n', '    ) external returns (uint[] memory amounts);\n', '    function swapTokensForExactTokens(\n', '        uint amountOut,\n', '        uint amountInMax,\n', '        address[] calldata path,\n', '        address to,\n', '        uint deadline\n', '    ) external returns (uint[] memory amounts);\n', '    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)\n', '        external\n', '        payable\n', '        returns (uint[] memory amounts);\n', '    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)\n', '        external\n', '        returns (uint[] memory amounts);\n', '    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)\n', '        external\n', '        returns (uint[] memory amounts);\n', '    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)\n', '        external\n', '        payable\n', '        returns (uint[] memory amounts);\n', '\n', '    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);\n', '    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);\n', '    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);\n', '    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);\n', '    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);\n', '}\n', '\n', '{\n', '  "optimizer": {\n', '    "enabled": true,\n', '    "runs": 200\n', '  },\n', '  "outputSelection": {\n', '    "*": {\n', '      "*": [\n', '        "evm.bytecode",\n', '        "evm.deployedBytecode",\n', '        "abi"\n', '      ]\n', '    }\n', '  },\n', '  "libraries": {}\n', '}']