['/**\n', ' *Submitted for verification at Etherscan.io on 2021-03-03\n', '*/\n', '\n', '// SPDX-License-Identifier: MIT\n', 'pragma solidity 0.6.12;\n', 'pragma experimental ABIEncoderV2;\n', '\n', 'interface IERC20 {\n', '    function totalSupply() external view returns (uint256);\n', '    function balanceOf(address account) external view returns (uint256);\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '    function owner() external view returns (address);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'interface IMasterChef {\n', '    function BONUS_MULTIPLIER() external view returns (uint256);\n', '    function bonusEndBlock() external view returns (uint256);\n', '    function devaddr() external view returns (address);\n', '    function migrator() external view returns (address);\n', '    function owner() external view returns (address);\n', '    function startBlock() external view returns (uint256);\n', '    function sushi() external view returns (address);\n', '    function sushiPerBlock() external view returns (uint256);\n', '    function totalAllocPoint() external view returns (uint256);\n', '    function poolLength() external view returns (uint256);\n', '\n', '    function poolInfo(uint256 nr)\n', '        external\n', '        view\n', '        returns (\n', '            address,\n', '            uint256,\n', '            uint256,\n', '            uint256\n', '        );\n', '\n', '    function userInfo(uint256 nr, address who) external view returns (uint256, uint256);\n', '    function pendingSushi(uint256 nr, address who) external view returns (uint256);\n', '}\n', '\n', 'interface IPair is IERC20 {\n', '    function token0() external view returns (IERC20);\n', '    function token1() external view returns (IERC20);\n', '\n', '    function getReserves()\n', '        external\n', '        view\n', '        returns (\n', '            uint112,\n', '            uint112,\n', '            uint32\n', '        );\n', '}\n', '\n', 'interface IFactory {\n', '    function allPairsLength() external view returns (uint256);\n', '    function allPairs(uint256 i) external view returns (IPair);\n', '    function getPair(IERC20 token0, IERC20 token1) external view returns (IPair);\n', '    function feeTo() external view returns (address);\n', '    function feeToSetter() external view returns (address);\n', '}\n', '\n', 'library BoringMath {\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        require((c = a + b) >= b, "BoringMath: Add Overflow");\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        require((c = a - b) <= a, "BoringMath: Underflow");\n', '    }\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        require(b == 0 || (c = a * b) / b == a, "BoringMath: Mul Overflow");\n', '    }\n', '}\n', '\n', 'contract Ownable {\n', '    address public immutable owner;\n', '\n', '    constructor() internal {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(owner == msg.sender, "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '}\n', 'library BoringERC20 {\n', '    function returnDataToString(bytes memory data) internal pure returns (string memory) {\n', '        if (data.length >= 64) {\n', '            return abi.decode(data, (string));\n', '        } else if (data.length == 32) {\n', '            uint8 i = 0;\n', '            while(i < 32 && data[i] != 0) {\n', '                i++;\n', '            }\n', '            bytes memory bytesArray = new bytes(i);\n', '            for (i = 0; i < 32 && data[i] != 0; i++) {\n', '                bytesArray[i] = data[i];\n', '            }\n', '            return string(bytesArray);\n', '        } else {\n', '            return "???";\n', '        }\n', '    } \n', '    \n', '    function symbol(IERC20 token) internal view returns (string memory) {\n', '        (bool success, bytes memory data) = address(token).staticcall(abi.encodeWithSelector(0x95d89b41));\n', '        return success ? returnDataToString(data) : "???";\n', '    }\n', '\n', '    function name(IERC20 token) internal view returns (string memory) {\n', '        (bool success, bytes memory data) = address(token).staticcall(abi.encodeWithSelector(0x06fdde03));\n', '        return success ? returnDataToString(data) : "???";\n', '    }\n', '\n', '    function decimals(IERC20 token) internal view returns (uint8) {\n', '        (bool success, bytes memory data) = address(token).staticcall(abi.encodeWithSelector(0x313ce567));\n', '        return success && data.length == 32 ? abi.decode(data, (uint8)) : 18;\n', '    }\n', '}\n', '\n', 'library BoringPair {\n', '    function factory(IPair pair) internal view returns (IFactory) {\n', '        (bool success, bytes memory data) = address(pair).staticcall(abi.encodeWithSelector(0xc45a0155));\n', '        return success && data.length == 32 ? abi.decode(data, (IFactory)) : IFactory(0);\n', '    }\n', '}\n', '\n', 'interface IStrategy {\n', '    function skim(uint256 amount) external;\n', '    function harvest(uint256 balance, address sender) external returns (int256 amountAdded);\n', '    function withdraw(uint256 amount) external returns (uint256 actualAmount);\n', '    function exit(uint256 balance) external returns (int256 amountAdded);\n', '}\n', '\n', 'interface IBentoBox {\n', '    event LogDeploy(address indexed masterContract, bytes data, address indexed cloneAddress);\n', '    event LogDeposit(address indexed token, address indexed from, address indexed to, uint256 amount, uint256 share);\n', '    event LogFlashLoan(address indexed borrower, address indexed token, uint256 amount, uint256 feeAmount, address indexed receiver);\n', '    event LogRegisterProtocol(address indexed protocol);\n', '    event LogSetMasterContractApproval(address indexed masterContract, address indexed user, bool approved);\n', '    event LogStrategyDivest(address indexed token, uint256 amount);\n', '    event LogStrategyInvest(address indexed token, uint256 amount);\n', '    event LogStrategyLoss(address indexed token, uint256 amount);\n', '    event LogStrategyProfit(address indexed token, uint256 amount);\n', '    event LogStrategyQueued(address indexed token, address indexed strategy);\n', '    event LogStrategySet(address indexed token, address indexed strategy);\n', '    event LogStrategyTargetPercentage(address indexed token, uint256 targetPercentage);\n', '    event LogTransfer(address indexed token, address indexed from, address indexed to, uint256 share);\n', '    event LogWhiteListMasterContract(address indexed masterContract, bool approved);\n', '    event LogWithdraw(address indexed token, address indexed from, address indexed to, uint256 amount, uint256 share);\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '    function balanceOf(IERC20, address) external view returns (uint256);\n', '    function batch(bytes[] calldata calls, bool revertOnFail) external payable returns (bool[] memory successes, bytes[] memory results);\n', '    function claimOwnership() external;\n', '    function deploy(address masterContract, bytes calldata data, bool useCreate2) external payable;\n', '    function deposit(IERC20 token_, address from, address to, uint256 amount, uint256 share) external payable returns (uint256 amountOut, uint256 shareOut);\n', '    function harvest(IERC20 token, bool balance, uint256 maxChangeAmount) external;\n', '    function masterContractApproved(address, address) external view returns (bool);\n', '    function masterContractOf(address) external view returns (address);\n', '    function nonces(address) external view returns (uint256);\n', '    function owner() external view returns (address);\n', '    function pendingOwner() external view returns (address);\n', '    function pendingStrategy(IERC20) external view returns (IStrategy);\n', '    function permitToken(IERC20 token, address from, address to, uint256 amount, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external;\n', '    function registerProtocol() external;\n', '    function setMasterContractApproval(address user, address masterContract, bool approved, uint8 v, bytes32 r, bytes32 s) external;\n', '    function setStrategy(IERC20 token, IStrategy newStrategy) external;\n', '    function setStrategyTargetPercentage(IERC20 token, uint64 targetPercentage_) external;\n', '    function strategy(IERC20) external view returns (IStrategy);\n', '    function strategyData(IERC20) external view returns (uint64 strategyStartDate, uint64 targetPercentage, uint128 balance);\n', '    function toAmount(IERC20 token, uint256 share, bool roundUp) external view returns (uint256 amount);\n', '    function toShare(IERC20 token, uint256 amount, bool roundUp) external view returns (uint256 share);\n', '    function totals(IERC20) external view returns (uint128 elastic, uint128 base);\n', '    function transfer(IERC20 token, address from, address to, uint256 share) external;\n', '    function transferMultiple(IERC20 token, address from, address[] calldata tos, uint256[] calldata shares) external;\n', '    function transferOwnership(address newOwner, bool direct, bool renounce) external;\n', '    function whitelistMasterContract(address masterContract, bool approved) external;\n', '    function whitelistedMasterContracts(address) external view returns (bool);\n', '    function withdraw(IERC20 token_, address from, address to, uint256 amount, uint256 share) external returns (uint256 amountOut, uint256 shareOut);\n', '}\n', '\n', 'contract BoringHelper is Ownable {\n', '    IERC20 public WETH; // 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;\n', '    IFactory public sushiFactory; // IFactory(0xC0AEe478e3658e2610c5F7A4A2E1777cE9e4f2Ac);\n', '    IFactory public uniV2Factory; // IFactory(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f);\n', '    IBentoBox public bentoBox; // 0xB5891167796722331b7ea7824F036b3Bdcb4531C\n', '\n', '    constructor(\n', '        IERC20 WETH_,\n', '        IFactory sushiFactory_,\n', '        IFactory uniV2Factory_,\n', '        IBentoBox bentoBox_\n', '    ) public {\n', '        WETH = WETH_;\n', '        sushiFactory = sushiFactory_;\n', '        uniV2Factory = uniV2Factory_;\n', '        bentoBox = bentoBox_;\n', '    }\n', '\n', '    function getETHRate(IERC20 token) public view returns (uint256) {\n', '        if (token == WETH) {\n', '            return 1e18;\n', '        }\n', '        IPair pairUniV2 = IPair(uniV2Factory.getPair(token, WETH));\n', '        IPair pairSushi = IPair(sushiFactory.getPair(token, WETH));\n', '        if (address(pairUniV2) == address(0) && address(pairSushi) == address(0)) {\n', '            return 0;\n', '        }\n', '\n', '        uint112 reserve0;\n', '        uint112 reserve1;\n', '        IERC20 token0;\n', '        if (address(pairUniV2) != address(0)) {\n', '            (uint112 reserve0UniV2, uint112 reserve1UniV2, ) = pairUniV2.getReserves();\n', '            reserve0 += reserve0UniV2;\n', '            reserve1 += reserve1UniV2;\n', '            token0 = pairUniV2.token0();\n', '        }\n', '\n', '        if (address(pairSushi) != address(0)) {\n', '            (uint112 reserve0Sushi, uint112 reserve1Sushi, ) = pairSushi.getReserves();\n', '            reserve0 += reserve0Sushi;\n', '            reserve1 += reserve1Sushi;\n', '            if (token0 == IERC20(0)) {\n', '                token0 = pairSushi.token0();\n', '            }\n', '        }\n', '\n', '        if (token0 == WETH) {\n', '            return uint256(reserve1) * 1e18 / reserve0;\n', '        } else {\n', '            return uint256(reserve0) * 1e18 / reserve1;\n', '        }\n', '    }\n', '\n', '    struct BalanceFull {\n', '        IERC20 token;\n', '        uint256 balance;\n', '        uint256 bentoBalance;\n', '        uint256 bentoAllowance;\n', '        uint128 bentoAmount;\n', '        uint128 bentoShare;\n', '        uint256 rate;\n', '    }\n', '\n', '    function getBalances(address who, IERC20[] calldata addresses) public view returns (BalanceFull[] memory) {\n', '        BalanceFull[] memory balances = new BalanceFull[](addresses.length);\n', '\n', '        for (uint256 i = 0; i < addresses.length; i++) {\n', '            IERC20 token = addresses[i];\n', '            balances[i].token = token;\n', '            balances[i].balance = token.balanceOf(who);\n', '            balances[i].bentoAllowance = token.allowance(who, address(bentoBox));\n', '            balances[i].bentoBalance = bentoBox.balanceOf(token, who);\n', '            if (balances[i].bentoBalance != 0) {\n', '                (balances[i].bentoAmount, balances[i].bentoShare) = bentoBox.totals(token);\n', '            }\n', '            balances[i].rate = getETHRate(token);\n', '        }\n', '\n', '        return balances;\n', '    }\n', '}']