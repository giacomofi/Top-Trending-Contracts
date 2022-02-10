['/**\n', ' *Submitted for verification at Etherscan.io on 2021-06-16\n', '*/\n', '\n', '/**\n', ' *Submitted for verification at Etherscan.io on 2021-06-14\n', '*/\n', '\n', '// SPDX-License-Identifier: MIXED\n', '\n', '// File @boringcrypto/boring-solidity/contracts/libraries/[email\xa0protected]\n', '// License-Identifier: MIT\n', 'pragma solidity 0.6.12;\n', '\n', '/// @notice A library for performing overflow-/underflow-safe math,\n', '/// updated with awesomeness from of DappHub (https://github.com/dapphub/ds-math).\n', 'library BoringMath {\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        require((c = a + b) >= b, "BoringMath: Add Overflow");\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        require((c = a - b) <= a, "BoringMath: Underflow");\n', '    }\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        require(b == 0 || (c = a * b) / b == a, "BoringMath: Mul Overflow");\n', '    }\n', '\n', '    function to128(uint256 a) internal pure returns (uint128 c) {\n', '        require(a <= uint128(-1), "BoringMath: uint128 Overflow");\n', '        c = uint128(a);\n', '    }\n', '\n', '    function to64(uint256 a) internal pure returns (uint64 c) {\n', '        require(a <= uint64(-1), "BoringMath: uint64 Overflow");\n', '        c = uint64(a);\n', '    }\n', '\n', '    function to32(uint256 a) internal pure returns (uint32 c) {\n', '        require(a <= uint32(-1), "BoringMath: uint32 Overflow");\n', '        c = uint32(a);\n', '    }\n', '}\n', '\n', '/// @notice A library for performing overflow-/underflow-safe addition and subtraction on uint128.\n', 'library BoringMath128 {\n', '    function add(uint128 a, uint128 b) internal pure returns (uint128 c) {\n', '        require((c = a + b) >= b, "BoringMath: Add Overflow");\n', '    }\n', '\n', '    function sub(uint128 a, uint128 b) internal pure returns (uint128 c) {\n', '        require((c = a - b) <= a, "BoringMath: Underflow");\n', '    }\n', '}\n', '\n', '/// @notice A library for performing overflow-/underflow-safe addition and subtraction on uint64.\n', 'library BoringMath64 {\n', '    function add(uint64 a, uint64 b) internal pure returns (uint64 c) {\n', '        require((c = a + b) >= b, "BoringMath: Add Overflow");\n', '    }\n', '\n', '    function sub(uint64 a, uint64 b) internal pure returns (uint64 c) {\n', '        require((c = a - b) <= a, "BoringMath: Underflow");\n', '    }\n', '}\n', '\n', '/// @notice A library for performing overflow-/underflow-safe addition and subtraction on uint32.\n', 'library BoringMath32 {\n', '    function add(uint32 a, uint32 b) internal pure returns (uint32 c) {\n', '        require((c = a + b) >= b, "BoringMath: Add Overflow");\n', '    }\n', '\n', '    function sub(uint32 a, uint32 b) internal pure returns (uint32 c) {\n', '        require((c = a - b) <= a, "BoringMath: Underflow");\n', '    }\n', '}\n', '\n', '// File @sushiswap/core/contracts/uniswapv2/interfaces/[email\xa0protected]\n', '// License-Identifier: GPL-3.0\n', '\n', 'pragma solidity >=0.5.0;\n', '\n', 'interface IUniswapV2Factory {\n', '    event PairCreated(address indexed token0, address indexed token1, address pair, uint);\n', '\n', '    function feeTo() external view returns (address);\n', '    function feeToSetter() external view returns (address);\n', '    function migrator() external view returns (address);\n', '\n', '    function getPair(address tokenA, address tokenB) external view returns (address pair);\n', '    function allPairs(uint) external view returns (address pair);\n', '    function allPairsLength() external view returns (uint);\n', '\n', '    function createPair(address tokenA, address tokenB) external returns (address pair);\n', '\n', '    function setFeeTo(address) external;\n', '    function setFeeToSetter(address) external;\n', '    function setMigrator(address) external;\n', '}\n', '\n', '// File @sushiswap/core/contracts/uniswapv2/interfaces/[email\xa0protected]\n', '// License-Identifier: GPL-3.0\n', '\n', 'pragma solidity >=0.5.0;\n', '\n', 'interface IUniswapV2Pair {\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '\n', '    function name() external pure returns (string memory);\n', '    function symbol() external pure returns (string memory);\n', '    function decimals() external pure returns (uint8);\n', '    function totalSupply() external view returns (uint);\n', '    function balanceOf(address owner) external view returns (uint);\n', '    function allowance(address owner, address spender) external view returns (uint);\n', '\n', '    function approve(address spender, uint value) external returns (bool);\n', '    function transfer(address to, uint value) external returns (bool);\n', '    function transferFrom(address from, address to, uint value) external returns (bool);\n', '\n', '    function DOMAIN_SEPARATOR() external view returns (bytes32);\n', '    function PERMIT_TYPEHASH() external pure returns (bytes32);\n', '    function nonces(address owner) external view returns (uint);\n', '\n', '    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;\n', '\n', '    event Mint(address indexed sender, uint amount0, uint amount1);\n', '    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);\n', '    event Swap(\n', '        address indexed sender,\n', '        uint amount0In,\n', '        uint amount1In,\n', '        uint amount0Out,\n', '        uint amount1Out,\n', '        address indexed to\n', '    );\n', '    event Sync(uint112 reserve0, uint112 reserve1);\n', '\n', '    function MINIMUM_LIQUIDITY() external pure returns (uint);\n', '    function factory() external view returns (address);\n', '    function token0() external view returns (address);\n', '    function token1() external view returns (address);\n', '    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);\n', '    function price0CumulativeLast() external view returns (uint);\n', '    function price1CumulativeLast() external view returns (uint);\n', '    function kLast() external view returns (uint);\n', '\n', '    function mint(address to) external returns (uint liquidity);\n', '    function burn(address to) external returns (uint amount0, uint amount1);\n', '    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;\n', '    function skim(address to) external;\n', '    function sync() external;\n', '\n', '    function initialize(address, address) external;\n', '}\n', '\n', '// File @boringcrypto/boring-solidity/contracts/interfaces/[email\xa0protected]\n', '// License-Identifier: MIT\n', 'pragma solidity 0.6.12;\n', '\n', 'interface IERC20 {\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '    /// @notice EIP 2612\n', '    function permit(\n', '        address owner,\n', '        address spender,\n', '        uint256 value,\n', '        uint256 deadline,\n', '        uint8 v,\n', '        bytes32 r,\n', '        bytes32 s\n', '    ) external;\n', '}\n', '\n', '// File contracts/interfaces/ISwapper.sol\n', '// License-Identifier: MIT\n', 'pragma solidity 0.6.12;\n', '\n', 'interface ISwapper {\n', "    /// @notice Withdraws 'amountFrom' of token 'from' from the BentoBox account for this swapper.\n", "    /// Swaps it for at least 'amountToMin' of token 'to'.\n", "    /// Transfers the swapped tokens of 'to' into the BentoBox using a plain ERC20 transfer.\n", "    /// Returns the amount of tokens 'to' transferred to BentoBox.\n", '    /// (The BentoBox skim function will be used by the caller to get the swapped funds).\n', '    function swap(\n', '        IERC20 fromToken,\n', '        IERC20 toToken,\n', '        address recipient,\n', '        uint256 shareToMin,\n', '        uint256 shareFrom\n', '    ) external returns (uint256 extraShare, uint256 shareReturned);\n', '\n', "    /// @notice Calculates the amount of token 'from' needed to complete the swap (amountFrom),\n", '    /// this should be less than or equal to amountFromMax.\n', "    /// Withdraws 'amountFrom' of token 'from' from the BentoBox account for this swapper.\n", "    /// Swaps it for exactly 'exactAmountTo' of token 'to'.\n", "    /// Transfers the swapped tokens of 'to' into the BentoBox using a plain ERC20 transfer.\n", "    /// Transfers allocated, but unused 'from' tokens within the BentoBox to 'refundTo' (amountFromMax - amountFrom).\n", "    /// Returns the amount of 'from' tokens withdrawn from BentoBox (amountFrom).\n", '    /// (The BentoBox skim function will be used by the caller to get the swapped funds).\n', '    function swapExact(\n', '        IERC20 fromToken,\n', '        IERC20 toToken,\n', '        address recipient,\n', '        address refundTo,\n', '        uint256 shareFromSupplied,\n', '        uint256 shareToExact\n', '    ) external returns (uint256 shareUsed, uint256 shareReturned);\n', '}\n', '\n', '// File @boringcrypto/boring-solidity/contracts/libraries/[email\xa0protected]\n', '// License-Identifier: MIT\n', 'pragma solidity 0.6.12;\n', '\n', 'struct Rebase {\n', '    uint128 elastic;\n', '    uint128 base;\n', '}\n', '\n', '/// @notice A rebasing library using overflow-/underflow-safe math.\n', 'library RebaseLibrary {\n', '    using BoringMath for uint256;\n', '    using BoringMath128 for uint128;\n', '\n', '    /// @notice Calculates the base value in relationship to `elastic` and `total`.\n', '    function toBase(\n', '        Rebase memory total,\n', '        uint256 elastic,\n', '        bool roundUp\n', '    ) internal pure returns (uint256 base) {\n', '        if (total.elastic == 0) {\n', '            base = elastic;\n', '        } else {\n', '            base = elastic.mul(total.base) / total.elastic;\n', '            if (roundUp && base.mul(total.elastic) / total.base < elastic) {\n', '                base = base.add(1);\n', '            }\n', '        }\n', '    }\n', '\n', '    /// @notice Calculates the elastic value in relationship to `base` and `total`.\n', '    function toElastic(\n', '        Rebase memory total,\n', '        uint256 base,\n', '        bool roundUp\n', '    ) internal pure returns (uint256 elastic) {\n', '        if (total.base == 0) {\n', '            elastic = base;\n', '        } else {\n', '            elastic = base.mul(total.elastic) / total.base;\n', '            if (roundUp && elastic.mul(total.base) / total.elastic < base) {\n', '                elastic = elastic.add(1);\n', '            }\n', '        }\n', '    }\n', '\n', '    /// @notice Add `elastic` to `total` and doubles `total.base`.\n', '    /// @return (Rebase) The new total.\n', '    /// @return base in relationship to `elastic`.\n', '    function add(\n', '        Rebase memory total,\n', '        uint256 elastic,\n', '        bool roundUp\n', '    ) internal pure returns (Rebase memory, uint256 base) {\n', '        base = toBase(total, elastic, roundUp);\n', '        total.elastic = total.elastic.add(elastic.to128());\n', '        total.base = total.base.add(base.to128());\n', '        return (total, base);\n', '    }\n', '\n', '    /// @notice Sub `base` from `total` and update `total.elastic`.\n', '    /// @return (Rebase) The new total.\n', '    /// @return elastic in relationship to `base`.\n', '    function sub(\n', '        Rebase memory total,\n', '        uint256 base,\n', '        bool roundUp\n', '    ) internal pure returns (Rebase memory, uint256 elastic) {\n', '        elastic = toElastic(total, base, roundUp);\n', '        total.elastic = total.elastic.sub(elastic.to128());\n', '        total.base = total.base.sub(base.to128());\n', '        return (total, elastic);\n', '    }\n', '\n', '    /// @notice Add `elastic` and `base` to `total`.\n', '    function add(\n', '        Rebase memory total,\n', '        uint256 elastic,\n', '        uint256 base\n', '    ) internal pure returns (Rebase memory) {\n', '        total.elastic = total.elastic.add(elastic.to128());\n', '        total.base = total.base.add(base.to128());\n', '        return total;\n', '    }\n', '\n', '    /// @notice Subtract `elastic` and `base` to `total`.\n', '    function sub(\n', '        Rebase memory total,\n', '        uint256 elastic,\n', '        uint256 base\n', '    ) internal pure returns (Rebase memory) {\n', '        total.elastic = total.elastic.sub(elastic.to128());\n', '        total.base = total.base.sub(base.to128());\n', '        return total;\n', '    }\n', '\n', '    /// @notice Add `elastic` to `total` and update storage.\n', '    /// @return newElastic Returns updated `elastic`.\n', '    function addElastic(Rebase storage total, uint256 elastic) internal returns (uint256 newElastic) {\n', '        newElastic = total.elastic = total.elastic.add(elastic.to128());\n', '    }\n', '\n', '    /// @notice Subtract `elastic` from `total` and update storage.\n', '    /// @return newElastic Returns updated `elastic`.\n', '    function subElastic(Rebase storage total, uint256 elastic) internal returns (uint256 newElastic) {\n', '        newElastic = total.elastic = total.elastic.sub(elastic.to128());\n', '    }\n', '}\n', '\n', '// File @sushiswap/bentobox-sdk/contracts/[email\xa0protected]\n', '// License-Identifier: MIT\n', 'pragma solidity 0.6.12;\n', '\n', 'interface IBatchFlashBorrower {\n', '    function onBatchFlashLoan(\n', '        address sender,\n', '        IERC20[] calldata tokens,\n', '        uint256[] calldata amounts,\n', '        uint256[] calldata fees,\n', '        bytes calldata data\n', '    ) external;\n', '}\n', '\n', '// File @sushiswap/bentobox-sdk/contracts/[email\xa0protected]\n', '// License-Identifier: MIT\n', 'pragma solidity 0.6.12;\n', '\n', 'interface IFlashBorrower {\n', '    function onFlashLoan(\n', '        address sender,\n', '        IERC20 token,\n', '        uint256 amount,\n', '        uint256 fee,\n', '        bytes calldata data\n', '    ) external;\n', '}\n', '\n', '// File @sushiswap/bentobox-sdk/contracts/[email\xa0protected]\n', '// License-Identifier: MIT\n', 'pragma solidity 0.6.12;\n', '\n', 'interface IStrategy {\n', '    // Send the assets to the Strategy and call skim to invest them\n', '    function skim(uint256 amount) external;\n', '\n', '    // Harvest any profits made converted to the asset and pass them to the caller\n', '    function harvest(uint256 balance, address sender) external returns (int256 amountAdded);\n', '\n', '    // Withdraw assets. The returned amount can differ from the requested amount due to rounding.\n', "    // The actualAmount should be very close to the amount. The difference should NOT be used to report a loss. That's what harvest is for.\n", '    function withdraw(uint256 amount) external returns (uint256 actualAmount);\n', '\n', "    // Withdraw all assets in the safest way possible. This shouldn't fail.\n", '    function exit(uint256 balance) external returns (int256 amountAdded);\n', '}\n', '\n', '// File @sushiswap/bentobox-sdk/contracts/[email\xa0protected]\n', '// License-Identifier: MIT\n', 'pragma solidity 0.6.12;\n', 'pragma experimental ABIEncoderV2;\n', '\n', '\n', '\n', '\n', '\n', 'interface IBentoBoxV1 {\n', '    event LogDeploy(address indexed masterContract, bytes data, address indexed cloneAddress);\n', '    event LogDeposit(address indexed token, address indexed from, address indexed to, uint256 amount, uint256 share);\n', '    event LogFlashLoan(address indexed borrower, address indexed token, uint256 amount, uint256 feeAmount, address indexed receiver);\n', '    event LogRegisterProtocol(address indexed protocol);\n', '    event LogSetMasterContractApproval(address indexed masterContract, address indexed user, bool approved);\n', '    event LogStrategyDivest(address indexed token, uint256 amount);\n', '    event LogStrategyInvest(address indexed token, uint256 amount);\n', '    event LogStrategyLoss(address indexed token, uint256 amount);\n', '    event LogStrategyProfit(address indexed token, uint256 amount);\n', '    event LogStrategyQueued(address indexed token, address indexed strategy);\n', '    event LogStrategySet(address indexed token, address indexed strategy);\n', '    event LogStrategyTargetPercentage(address indexed token, uint256 targetPercentage);\n', '    event LogTransfer(address indexed token, address indexed from, address indexed to, uint256 share);\n', '    event LogWhiteListMasterContract(address indexed masterContract, bool approved);\n', '    event LogWithdraw(address indexed token, address indexed from, address indexed to, uint256 amount, uint256 share);\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '    function balanceOf(IERC20, address) external view returns (uint256);\n', '    function batch(bytes[] calldata calls, bool revertOnFail) external payable returns (bool[] memory successes, bytes[] memory results);\n', '    function batchFlashLoan(IBatchFlashBorrower borrower, address[] calldata receivers, IERC20[] calldata tokens, uint256[] calldata amounts, bytes calldata data) external;\n', '    function claimOwnership() external;\n', '    function deploy(address masterContract, bytes calldata data, bool useCreate2) external payable;\n', '    function deposit(IERC20 token_, address from, address to, uint256 amount, uint256 share) external payable returns (uint256 amountOut, uint256 shareOut);\n', '    function flashLoan(IFlashBorrower borrower, address receiver, IERC20 token, uint256 amount, bytes calldata data) external;\n', '    function harvest(IERC20 token, bool balance, uint256 maxChangeAmount) external;\n', '    function masterContractApproved(address, address) external view returns (bool);\n', '    function masterContractOf(address) external view returns (address);\n', '    function nonces(address) external view returns (uint256);\n', '    function owner() external view returns (address);\n', '    function pendingOwner() external view returns (address);\n', '    function pendingStrategy(IERC20) external view returns (IStrategy);\n', '    function permitToken(IERC20 token, address from, address to, uint256 amount, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external;\n', '    function registerProtocol() external;\n', '    function setMasterContractApproval(address user, address masterContract, bool approved, uint8 v, bytes32 r, bytes32 s) external;\n', '    function setStrategy(IERC20 token, IStrategy newStrategy) external;\n', '    function setStrategyTargetPercentage(IERC20 token, uint64 targetPercentage_) external;\n', '    function strategy(IERC20) external view returns (IStrategy);\n', '    function strategyData(IERC20) external view returns (uint64 strategyStartDate, uint64 targetPercentage, uint128 balance);\n', '    function toAmount(IERC20 token, uint256 share, bool roundUp) external view returns (uint256 amount);\n', '    function toShare(IERC20 token, uint256 amount, bool roundUp) external view returns (uint256 share);\n', '    function totals(IERC20) external view returns (Rebase memory totals_);\n', '    function transfer(IERC20 token, address from, address to, uint256 share) external;\n', '    function transferMultiple(IERC20 token, address from, address[] calldata tos, uint256[] calldata shares) external;\n', '    function transferOwnership(address newOwner, bool direct, bool renounce) external;\n', '    function whitelistMasterContract(address masterContract, bool approved) external;\n', '    function whitelistedMasterContracts(address) external view returns (bool);\n', '    function withdraw(IERC20 token_, address from, address to, uint256 amount, uint256 share) external returns (uint256 amountOut, uint256 shareOut);\n', '}\n', '\n', '// File contracts/swappers/YVXSushiSwapper.sol\n', '// License-Identifier: MIT\n', 'pragma solidity 0.6.12;\n', '\n', 'interface SushiBar {\n', '    function leave(uint256 share) external;\n', '}\n', '\n', 'interface Sushi is IERC20 {\n', '    function transfer(address _to, uint256 _value) external returns (bool success);\n', '}\n', '\n', 'contract SushiBarSwapper is ISwapper {\n', '    using BoringMath for uint256;\n', '\n', '    // Local variables\n', '    IBentoBoxV1 public constant bentoBox = IBentoBoxV1(0xF5BCE5077908a1b7370B9ae04AdC565EBd643966);\n', '    SushiBar public constant xSushi = SushiBar(0x8798249c2E607446EfB7Ad49eC89dD1865Ff4272);\n', '    Sushi public constant SUSHI = Sushi(0x6B3595068778DD592e39A122f4f5a5cF09C90fE2);\n', '    IUniswapV2Pair constant SUSHI_WETH = IUniswapV2Pair(0x795065dCc9f64b5614C407a6EFDC400DA6221FB0);\n', '    IUniswapV2Pair constant ETH_UST = IUniswapV2Pair(0x8B00eE8606CC70c2dce68dea0CEfe632CCA0fB7b);\n', '\n', '    constructor(\n', '    ) public {\n', '    }\n', '\n', '    // Given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset\n', '    function getAmountOut(\n', '        uint256 amountIn,\n', '        uint256 reserveIn,\n', '        uint256 reserveOut\n', '    ) internal pure returns (uint256 amountOut) {\n', '        uint256 amountInWithFee = amountIn.mul(997);\n', '        uint256 numerator = amountInWithFee.mul(reserveOut);\n', '        uint256 denominator = reserveIn.mul(1000).add(amountInWithFee);\n', '        amountOut = numerator / denominator;\n', '    }\n', '\n', '    // Given an output amount of an asset and pair reserves, returns a required input amount of the other asset\n', '    function getAmountIn(\n', '        uint256 amountOut,\n', '        uint256 reserveIn,\n', '        uint256 reserveOut\n', '    ) internal pure returns (uint256 amountIn) {\n', '        uint256 numerator = reserveIn.mul(amountOut).mul(1000);\n', '        uint256 denominator = reserveOut.sub(amountOut).mul(997);\n', '        amountIn = (numerator / denominator).add(1);\n', '    }\n', '\n', '    // Swaps to a flexible amount, from an exact input amount\n', '    /// @inheritdoc ISwapper\n', '    function swap(\n', '        IERC20 fromToken,\n', '        IERC20 toToken,\n', '        address recipient,\n', '        uint256 shareToMin,\n', '        uint256 shareFrom\n', '    ) public override returns (uint256 extraShare, uint256 shareReturned) {\n', '\n', '        {\n', '\n', '        (uint256 amountXSushiFrom, ) = bentoBox.withdraw(fromToken, address(this), address(this), 0, shareFrom);\n', '\n', '        xSushi.leave(amountXSushiFrom);\n', '\n', '        }\n', '        uint256 amountFirst;\n', '\n', '        {\n', '\n', '        uint256 amountFrom = SUSHI.balanceOf(address(this));\n', '        \n', '        SUSHI.transfer(address(SUSHI_WETH), amountFrom);\n', '\n', '        (uint256 reserve0, uint256 reserve1, ) = SUSHI_WETH.getReserves();\n', '        \n', '        amountFirst = getAmountOut(amountFrom, reserve0, reserve1);\n', '        \n', '        }\n', '\n', '        SUSHI_WETH.swap(0, amountFirst, address(ETH_UST), new bytes(0));\n', '\n', '        (uint256 reserve0, uint256 reserve1, ) = ETH_UST.getReserves();\n', '        \n', '        uint256 amountTo = getAmountOut(amountFirst, reserve1, reserve0);\n', '        ETH_UST.swap(amountTo, 0, address(bentoBox), new bytes(0));\n', '\n', '        (, shareReturned) = bentoBox.deposit(toToken, address(bentoBox), recipient, amountTo, 0);\n', '        extraShare = shareReturned.sub(shareToMin);\n', '    }\n', '\n', '    // Swaps to an exact amount, from a flexible input amount\n', '    /// @inheritdoc ISwapper\n', '    function swapExact(\n', '        IERC20 fromToken,\n', '        IERC20 toToken,\n', '        address recipient,\n', '        address refundTo,\n', '        uint256 shareFromSupplied,\n', '        uint256 shareToExact\n', '    ) public override returns (uint256 shareUsed, uint256 shareReturned) {\n', '        return (0,0);\n', '    }\n', '}']