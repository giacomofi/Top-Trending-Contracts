['// Dependency file: contracts/interfaces/IDemaxTransferListener.sol\n', '\n', '// pragma solidity >=0.6.6;\n', '\n', 'interface IDemaxTransferListener {\n', '    function transferNotify(address from, address to, address token, uint amount)  external returns (bool);\n', '}\n', '// Dependency file: contracts/modules/Ownable.sol\n', '\n', '// pragma solidity >=0.5.16;\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '    event OwnerChanged(address indexed _oldOwner, address indexed _newOwner);\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', "        require(msg.sender == owner, 'Ownable: FORBIDDEN');\n", '        _;\n', '    }\n', '\n', '    function changeOwner(address _newOwner) public onlyOwner {\n', "        require(_newOwner != address(0), 'Ownable: INVALID_ADDRESS');\n", '        emit OwnerChanged(owner, _newOwner);\n', '        owner = _newOwner;\n', '    }\n', '\n', '}\n', '\n', '// Dependency file: contracts/interfaces/IDemaxPair.sol\n', '\n', '// pragma solidity >=0.5.0;\n', '\n', 'interface IDemaxPair {\n', '  \n', '    event Mint(address indexed sender, uint amount0, uint amount1);\n', '    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);\n', '    event Swap(\n', '        address indexed sender,\n', '        uint amount0In,\n', '        uint amount1In,\n', '        uint amount0Out,\n', '        uint amount1Out,\n', '        address indexed to\n', '    );\n', '    event Sync(uint112 reserve0, uint112 reserve1);\n', '\n', '    function MINIMUM_LIQUIDITY() external pure returns (uint);\n', '    function factory() external view returns (address);\n', '    function token0() external view returns (address);\n', '    function token1() external view returns (address);\n', '    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);\n', '    function price0CumulativeLast() external view returns (uint);\n', '    function price1CumulativeLast() external view returns (uint);\n', '    function kLast() external view returns (uint);\n', '    function totalSupply() external view returns (uint);\n', '    function balanceOf(address) external view returns (uint);\n', '\n', '    function mint(address to) external returns (uint liquidity);\n', '    function burn(address from, address to, uint amount) external returns (uint amount0, uint amount1);\n', '    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;\n', '    function skim(address to) external;\n', '    function sync() external;\n', '\n', '    function initialize(address tokenA, address tokenB, address platform, address dgas) external;\n', '    function swapFee(uint amount, address token, address to) external ;\n', '    function queryReward() external view returns (uint rewardAmount, uint blockNumber);\n', '    function mintReward() external returns (uint rewardAmount);\n', '    function getDGASReserve() external view returns (uint);\n', '}\n', '\n', '// Dependency file: contracts/interfaces/IDemaxFactory.sol\n', '\n', '// pragma solidity >=0.5.0;\n', '\n', 'interface IDemaxFactory {\n', '    event PairCreated(address indexed token0, address indexed token1, address pair, uint);\n', '\n', '    function contractCodeHash() external view returns (bytes32);\n', '    function getPair(address tokenA, address tokenB) external view returns (address pair);\n', '    function isPair(address pair) external view returns (bool);\n', '    function allPairs(uint) external view returns (address pair);\n', '    function allPairsLength() external view returns (uint);\n', '    function playerPairs(address player, uint index) external view returns (address pair);\n', '    function getPlayerPairCount(address player) external view returns (uint);\n', '\n', '    function createPair(address tokenA, address tokenB) external returns (address pair);\n', '    function addPlayerPair(address player, address _pair) external returns (bool);\n', '}\n', '\n', '// Dependency file: contracts/interfaces/IERC20.sol\n', '\n', '// pragma solidity >=0.5.0;\n', '\n', 'interface IERC20 {\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '\n', '    function name() external view returns (string memory);\n', '    function symbol() external view returns (string memory);\n', '    function decimals() external view returns (uint8);\n', '    function totalSupply() external view returns (uint);\n', '    function balanceOf(address owner) external view returns (uint);\n', '    function allowance(address owner, address spender) external view returns (uint);\n', '\n', '    function approve(address spender, uint value) external returns (bool);\n', '    function transfer(address to, uint value) external returns (bool);\n', '    function transferFrom(address from, address to, uint value) external returns (bool);\n', '}\n', '\n', '// Dependency file: contracts/interfaces/IDemaxConfig.sol\n', '\n', '// pragma solidity >=0.5.0;\n', '\n', 'interface IDemaxConfig {\n', '    function dgas() external view returns (address);\n', '    function PERCENT_DENOMINATOR() external view returns (uint);\n', '    function getConfig(bytes32 _name) external view returns (uint minValue, uint maxValue, uint maxSpan, uint value, uint enable);\n', '    function getConfigValue(bytes32 _name) external view returns (uint);\n', '    function changeConfigValue(bytes32 _name, uint _value) external returns (bool);\n', '    function checkToken(address _token) external view returns(bool);\n', '    function checkPair(address tokenA, address tokenB) external view returns (bool);\n', '    function listToken(address _token) external returns (bool);\n', '    function getDefaultListTokens() external returns (address[] memory);\n', '    function platform() external view returns  (address);\n', '}\n', '// Dependency file: contracts/interfaces/IDemaxGovernance.sol\n', '\n', '// pragma solidity >=0.5.0;\n', '\n', 'interface IDemaxGovernance {\n', '    function addPair(address _tokenA, address _tokenB) external returns (bool);\n', '    function addReward(uint _value) external returns (bool);\n', '}\n', '\n', '\n', '// Dependency file: contracts/interfaces/IWETH.sol\n', '\n', '// pragma solidity >=0.5.0;\n', '\n', 'interface IWETH {\n', '    function deposit() external payable;\n', '    function transfer(address to, uint value) external returns (bool);\n', '    function withdraw(uint) external;\n', '}\n', '\n', '// Dependency file: contracts/libraries/DemaxSwapLibrary.sol\n', '\n', '// pragma solidity >=0.5.0;\n', '\n', "// import '../interfaces/IDemaxPair.sol';\n", "// import '../interfaces/IDemaxFactory.sol';\n", '// import "./SafeMath.sol";\n', '\n', 'library DemaxSwapLibrary {\n', '    using SafeMath for uint;\n', '\n', '    function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {\n', "        require(tokenA != tokenB, 'DemaxSwapLibrary: IDENTICAL_ADDRESSES');\n", '        (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);\n', "        require(token0 != address(0), 'DemaxSwapLibrary: ZERO_ADDRESS');\n", '    }\n', '\n', '     function pairFor(address factory, address tokenA, address tokenB) internal view returns (address pair) {\n', '        (address token0, address token1) = sortTokens(tokenA, tokenB);\n', '        bytes32 salt = keccak256(abi.encodePacked(token0, token1));\n', '        bytes32 rawAddress = keccak256(\n', '         abi.encodePacked(\n', '            bytes1(0xff),\n', '            factory,\n', '            salt,\n', '            IDemaxFactory(factory).contractCodeHash()\n', '            )\n', '        );\n', '     return address(bytes20(rawAddress << 96));\n', '    }\n', '\n', '    function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {\n', '        (address token0,) = sortTokens(tokenA, tokenB);\n', '        (uint reserve0, uint reserve1,) = IDemaxPair(pairFor(factory, tokenA, tokenB)).getReserves();\n', '        (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);\n', '    }\n', '    \n', '    function quoteEnhance(address factory, address tokenA, address tokenB, uint amountA) internal view returns(uint amountB) {\n', '        (uint reserveA, uint reserveB) = getReserves(factory, tokenA, tokenB);\n', '        return quote(amountA, reserveA, reserveB);\n', '    }\n', '\n', '    function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {\n', "        require(amountA > 0, 'DemaxSwapLibrary: INSUFFICIENT_AMOUNT');\n", "        require(reserveA > 0 && reserveB > 0, 'DemaxSwapLibrary: INSUFFICIENT_LIQUIDITY');\n", '        amountB = amountA.mul(reserveB) / reserveA;\n', '    }\n', '\n', '    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {\n', "        require(amountIn > 0, 'DemaxSwapLibrary: INSUFFICIENT_INPUT_AMOUNT');\n", "        require(reserveIn > 0 && reserveOut > 0, 'DemaxSwapLibrary: INSUFFICIENT_LIQUIDITY');\n", '        uint numerator = amountIn.mul(reserveOut);\n', '        uint denominator = reserveIn.add(amountIn);\n', '        amountOut = numerator / denominator;\n', '    }\n', '    \n', '    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {\n', "        require(amountOut > 0, 'DemaxSwapLibrary: INSUFFICIENT_OUTPUT_AMOUNT');\n", "        require(reserveIn > 0 && reserveOut > 0, 'DemaxSwapLibrary: INSUFFICIENT_LIQUIDITY');\n", '        uint numerator = reserveIn.mul(amountOut);\n', '        uint denominator = reserveOut.sub(amountOut);\n', '        amountIn = (numerator / denominator).add(1);\n', '    }\n', '\n', '}\n', '// Dependency file: contracts/libraries/TransferHelper.sol\n', '\n', '// SPDX-License-Identifier: GPL-3.0-or-later\n', '\n', '// pragma solidity >=0.6.0;\n', '\n', '// helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false\n', 'library TransferHelper {\n', '    function safeApprove(address token, address to, uint value) internal {\n', "        // bytes4(keccak256(bytes('approve(address,uint256)')));\n", '        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));\n', "        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');\n", '    }\n', '\n', '    function safeTransfer(address token, address to, uint value) internal {\n', "        // bytes4(keccak256(bytes('transfer(address,uint256)')));\n", '        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));\n', "        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');\n", '    }\n', '\n', '    function safeTransferFrom(address token, address from, address to, uint value) internal {\n', "        // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));\n", '        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));\n', "        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');\n", '    }\n', '\n', '    function safeTransferETH(address to, uint value) internal {\n', '        (bool success,) = to.call{value:value}(new bytes(0));\n', "        require(success, 'TransferHelper: ETH_TRANSFER_FAILED');\n", '    }\n', '}\n', '\n', '// Dependency file: contracts/libraries/SafeMath.sol\n', '\n', '// pragma solidity >=0.5.0;\n', '\n', '// a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)\n', '\n', 'library SafeMath {\n', '    function add(uint x, uint y) internal pure returns (uint z) {\n', "        require((z = x + y) >= x, 'ds-math-add-overflow');\n", '    }\n', '\n', '    function sub(uint x, uint y) internal pure returns (uint z) {\n', "        require((z = x - y) <= x, 'ds-math-sub-underflow');\n", '    }\n', '\n', '    function mul(uint x, uint y) internal pure returns (uint z) {\n', "        require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');\n", '    }\n', '}\n', '\n', '// Dependency file: contracts/libraries/ConfigNames.sol\n', '\n', '// pragma solidity >=0.5.16;\n', '\n', 'library ConfigNames {\n', "    bytes32 public constant PRODUCE_DGAS_RATE = bytes32('PRODUCE_DGAS_RATE');\n", "    bytes32 public constant SWAP_FEE_PERCENT = bytes32('SWAP_FEE_PERCENT');\n", "    bytes32 public constant LIST_DGAS_AMOUNT = bytes32('LIST_DGAS_AMOUNT');\n", "    bytes32 public constant UNSTAKE_DURATION = bytes32('UNSTAKE_DURATION');\n", "    bytes32 public constant REMOVE_LIQUIDITY_DURATION = bytes32('REMOVE_LIQUIDITY_DURATION');\n", "    bytes32 public constant TOKEN_TO_DGAS_PAIR_MIN_PERCENT = bytes32('TOKEN_TO_DGAS_PAIR_MIN_PERCENT');\n", "    bytes32 public constant LIST_TOKEN_FAILURE_BURN_PRECENT = bytes32('LIST_TOKEN_FAILURE_BURN_PRECENT');\n", "    bytes32 public constant LIST_TOKEN_SUCCESS_BURN_PRECENT = bytes32('LIST_TOKEN_SUCCESS_BURN_PRECENT');\n", "    bytes32 public constant PROPOSAL_DGAS_AMOUNT = bytes32('PROPOSAL_DGAS_AMOUNT');\n", "    bytes32 public constant VOTE_DURATION = bytes32('VOTE_DURATION');\n", "    bytes32 public constant VOTE_REWARD_PERCENT = bytes32('VOTE_REWARD_PERCENT');\n", "    bytes32 public constant PAIR_SWITCH = bytes32('PAIR_SWITCH');\n", "    bytes32 public constant TOKEN_PENGDING_SWITCH = bytes32('TOKEN_PENGDING_SWITCH');\n", "    bytes32 public constant TOKEN_PENGDING_TIME = bytes32('TOKEN_PENGDING_TIME');\n", '}\n', 'pragma solidity >=0.6.6;\n', "// import './libraries/ConfigNames.sol';\n", "// import './libraries/SafeMath.sol';\n", "// import './libraries/TransferHelper.sol';\n", "// import './libraries/DemaxSwapLibrary.sol';\n", "// import './interfaces/IWETH.sol';\n", "// import './interfaces/IDemaxGovernance.sol';\n", "// import './interfaces/IDemaxConfig.sol';\n", "// import './interfaces/IERC20.sol';\n", "// import './interfaces/IDemaxFactory.sol';\n", "// import './interfaces/IDemaxPair.sol';\n", "// import './modules/Ownable.sol';\n", "// import './interfaces/IDemaxTransferListener.sol';\n", '\n', 'contract DemaxPlatform is Ownable {\n', '    uint public version = 1;\n', '    address public DGAS;\n', '    address public CONFIG;\n', '    address public FACTORY;\n', '    address public WETH;\n', '    address public GOVERNANCE;\n', '    address public TRANSFER_LISTENER;\n', '    uint256 public constant PERCENT_DENOMINATOR = 10000;\n', '\n', '    event AddLiquidity(\n', '        address indexed player,\n', '        address indexed tokenA,\n', '        address indexed tokenB,\n', '        uint256 amountA,\n', '        uint256 amountB\n', '    );\n', '    event RemoveLiquidity(\n', '        address indexed player,\n', '        address indexed tokenA,\n', '        address indexed tokenB,\n', '        uint256 amountA,\n', '        uint256 amountB\n', '    );\n', '    event SwapToken(\n', '        address indexed receiver,\n', '        address indexed fromToken,\n', '        address indexed toToken,\n', '        uint256 inAmount,\n', '        uint256 outAmount\n', '    );\n', '\n', '    receive() external payable {\n', '        assert(msg.sender == WETH);\n', '    }\n', '\n', '    modifier ensure(uint256 deadline) {\n', "        require(deadline >= block.timestamp, 'DEMAX PLATFORM : EXPIRED');\n", '        _;\n', '    }\n', '\n', '    function initialize(\n', '        address _DGAS,\n', '        address _CONFIG,\n', '        address _FACTORY,\n', '        address _WETH,\n', '        address _GOVERNANCE,\n', '        address _TRANSFER_LISTENER\n', '    ) external onlyOwner {\n', '        DGAS = _DGAS;\n', '        CONFIG = _CONFIG;\n', '        FACTORY = _FACTORY;\n', '        WETH = _WETH;\n', '        GOVERNANCE = _GOVERNANCE;\n', '        TRANSFER_LISTENER = _TRANSFER_LISTENER;\n', '    }\n', '\n', '    function _addLiquidity(\n', '        address tokenA,\n', '        address tokenB,\n', '        uint256 amountADesired,\n', '        uint256 amountBDesired,\n', '        uint256 amountAMin,\n', '        uint256 amountBMin\n', '    ) internal returns (uint256 amountA, uint256 amountB) {\n', '        if (IDemaxFactory(FACTORY).getPair(tokenA, tokenB) == address(0)) {\n', '            IDemaxFactory(FACTORY).createPair(tokenA, tokenB);\n', '        }\n', '        require(\n', '            IDemaxConfig(CONFIG).checkPair(tokenA, tokenB),\n', "            'DEMAX PLATFORM : ADD LIQUIDITY PAIR CONFIG CHECK FAIL'\n", '        );\n', '        (uint256 reserveA, uint256 reserveB) = DemaxSwapLibrary.getReserves(FACTORY, tokenA, tokenB);\n', '        if (reserveA == 0 && reserveB == 0) {\n', '            (amountA, amountB) = (amountADesired, amountBDesired);\n', '        } else {\n', '            uint256 amountBOptimal = DemaxSwapLibrary.quote(amountADesired, reserveA, reserveB);\n', '            if (amountBOptimal <= amountBDesired) {\n', "                require(amountBOptimal >= amountBMin, 'DEMAX PLATFORM : INSUFFICIENT_B_AMOUNT');\n", '                (amountA, amountB) = (amountADesired, amountBOptimal);\n', '            } else {\n', '                uint256 amountAOptimal = DemaxSwapLibrary.quote(amountBDesired, reserveB, reserveA);\n', '                assert(amountAOptimal <= amountADesired);\n', "                require(amountAOptimal >= amountAMin, 'DEMAX PLATFORM : INSUFFICIENT_A_AMOUNT');\n", '                (amountA, amountB) = (amountAOptimal, amountBDesired);\n', '            }\n', '        }\n', '        IDemaxFactory(FACTORY).addPlayerPair(msg.sender, IDemaxFactory(FACTORY).getPair(tokenA, tokenB));\n', '    }\n', '\n', '    function _calcDGASRate(\n', '        address tokenA,\n', '        address tokenB,\n', '        uint256 amountA,\n', '        uint256 amountB\n', '    ) internal view returns (uint256 value) {\n', '        uint256 tokenAValue = 0;\n', '        uint256 tokenBValue = 0;\n', '        if (tokenA == WETH || tokenA == DGAS) {\n', '            tokenAValue = tokenA == WETH ? amountA : DemaxSwapLibrary.quoteEnhance(FACTORY, DGAS, WETH, amountA);\n', '        }\n', '        if (tokenB == WETH || tokenB == DGAS) {\n', '            tokenBValue = tokenB == WETH ? amountB : DemaxSwapLibrary.quoteEnhance(FACTORY, DGAS, WETH, amountB);\n', '        }\n', '        return tokenAValue + tokenBValue;\n', '    }\n', '\n', '    function addLiquidity(\n', '        address tokenA,\n', '        address tokenB,\n', '        uint256 amountA,\n', '        uint256 amountB,\n', '        uint256 amountAMin,\n', '        uint256 amountBMin,\n', '        uint256 deadline\n', '    )\n', '        external\n', '        ensure(deadline)\n', '        returns (\n', '            uint256 _amountA,\n', '            uint256 _amountB,\n', '            uint256 _liquidity\n', '        )\n', '    {\n', '        (_amountA, _amountB) = _addLiquidity(tokenA, tokenB, amountA, amountB, amountAMin, amountBMin);\n', '        address pair = DemaxSwapLibrary.pairFor(FACTORY, tokenA, tokenB);\n', '        TransferHelper.safeTransferFrom(tokenA, msg.sender, pair, _amountA);\n', '        TransferHelper.safeTransferFrom(tokenB, msg.sender, pair, _amountB);\n', '        _liquidity = IDemaxPair(pair).mint(msg.sender);\n', '        _transferNotify(msg.sender, pair, tokenA, _amountA);\n', '        _transferNotify(msg.sender, pair, tokenB, _amountB);\n', '        emit AddLiquidity(msg.sender, tokenA, tokenB, _amountA, _amountB);\n', '    }\n', '\n', '    function addLiquidityETH(\n', '        address token,\n', '        uint256 amountTokenDesired,\n', '        uint256 amountTokenMin,\n', '        uint256 amountETHMin,\n', '        uint256 deadline\n', '    )\n', '        external\n', '        payable\n', '        ensure(deadline)\n', '        returns (\n', '            uint256 amountToken,\n', '            uint256 amountETH,\n', '            uint256 liquidity\n', '        )\n', '    {\n', '        (amountToken, amountETH) = _addLiquidity(\n', '            token,\n', '            WETH,\n', '            amountTokenDesired,\n', '            msg.value,\n', '            amountTokenMin,\n', '            amountETHMin\n', '        );\n', '        address pair = DemaxSwapLibrary.pairFor(FACTORY, token, WETH);\n', '        TransferHelper.safeTransferFrom(token, msg.sender, pair, amountToken);\n', '        IWETH(WETH).deposit{value: amountETH}();\n', '        assert(IWETH(WETH).transfer(pair, amountETH));\n', '        liquidity = IDemaxPair(pair).mint(msg.sender);\n', '        _transferNotify(msg.sender, pair, WETH, amountETH);\n', '        _transferNotify(msg.sender, pair, token, amountToken);\n', '        emit AddLiquidity(msg.sender, token, WETH, amountToken, amountETH);\n', '        if (msg.value > amountETH) TransferHelper.safeTransferETH(msg.sender, msg.value - amountETH);\n', '    }\n', '\n', '    function removeLiquidity(\n', '        address tokenA,\n', '        address tokenB,\n', '        uint256 liquidity,\n', '        uint256 amountAMin,\n', '        uint256 amountBMin,\n', '        address to,\n', '        uint256 deadline\n', '    ) public ensure(deadline) returns (uint256 amountA, uint256 amountB) {\n', '        address pair = DemaxSwapLibrary.pairFor(FACTORY, tokenA, tokenB);\n', '        uint256 _liquidity = liquidity;\n', '        address _tokenA = tokenA;\n', '        address _tokenB = tokenB;\n', '        (uint256 amount0, uint256 amount1) = IDemaxPair(pair).burn(msg.sender, to, _liquidity);\n', '        (address token0, ) = DemaxSwapLibrary.sortTokens(_tokenA, _tokenB);\n', '        (amountA, amountB) = _tokenA == token0 ? (amount0, amount1) : (amount1, amount0);\n', '        _transferNotify(pair, to, _tokenA, amountA);\n', '        _transferNotify(pair, to, _tokenB, amountB);\n', "        require(amountA >= amountAMin, 'DEMAX PLATFORM : INSUFFICIENT_A_AMOUNT');\n", "        require(amountB >= amountBMin, 'DEMAX PLATFORM : INSUFFICIENT_B_AMOUNT');\n", '        emit RemoveLiquidity(msg.sender, _tokenA, _tokenB, amountA, amountB);\n', '    }\n', '\n', '    function removeLiquidityETH(\n', '        address token,\n', '        uint256 liquidity,\n', '        uint256 amountTokenMin,\n', '        uint256 amountETHMin,\n', '        address to,\n', '        uint256 deadline\n', '    ) public ensure(deadline) returns (uint256 amountToken, uint256 amountETH) {\n', '        (amountToken, amountETH) = removeLiquidity(\n', '            token,\n', '            WETH,\n', '            liquidity,\n', '            amountTokenMin,\n', '            amountETHMin,\n', '            address(this),\n', '            deadline\n', '        );\n', '        TransferHelper.safeTransfer(token, to, amountToken);\n', '        IWETH(WETH).withdraw(amountETH);\n', '        TransferHelper.safeTransferETH(to, amountETH);\n', '        _transferNotify(DemaxSwapLibrary.pairFor(FACTORY, WETH, token), to, token, amountToken);\n', '        _transferNotify(DemaxSwapLibrary.pairFor(FACTORY, WETH, token), to, WETH, amountETH);\n', '        emit RemoveLiquidity(msg.sender, token, WETH, amountToken, amountETH);\n', '    }\n', '\n', '    function _getAmountsOut(\n', '        uint256 amount,\n', '        address[] memory path,\n', '        uint256 percent\n', '    ) internal view returns (uint256[] memory amountOuts) {\n', '        amountOuts = new uint256[](path.length);\n', '        amountOuts[0] = amount;\n', '        for (uint256 i = 0; i < path.length - 1; i++) {\n', '            address inPath = path[i];\n', '            address outPath = path[i + 1];\n', '            (uint256 reserveA, uint256 reserveB) = DemaxSwapLibrary.getReserves(FACTORY, inPath, outPath);\n', '            uint256 outAmount = SafeMath.mul(amountOuts[i], SafeMath.sub(PERCENT_DENOMINATOR, percent));\n', '            amountOuts[i + 1] = DemaxSwapLibrary.getAmountOut(outAmount / PERCENT_DENOMINATOR, reserveA, reserveB);\n', '        }\n', '    }\n', '\n', '    function _getAmountsIn(\n', '        uint256 amount,\n', '        address[] memory path,\n', '        uint256 percent\n', '    ) internal view returns (uint256[] memory amountIn) {\n', '        amountIn = new uint256[](path.length);\n', '        amountIn[path.length - 1] = amount;\n', '        for (uint256 i = path.length - 1; i > 0; i--) {\n', '            address inPath = path[i - 1];\n', '            address outPath = path[i];\n', '            (uint256 reserveA, uint256 reserveB) = DemaxSwapLibrary.getReserves(FACTORY, inPath, outPath);\n', '            uint256 inAmount = DemaxSwapLibrary.getAmountIn(amountIn[i], reserveA, reserveB);\n', '            amountIn[i - 1] = SafeMath.add(\n', '                SafeMath.mul(inAmount, PERCENT_DENOMINATOR) / SafeMath.sub(PERCENT_DENOMINATOR, percent),\n', '                1\n', '            );\n', '        }\n', '        amountIn = _getAmountsOut(amountIn[0], path, percent);\n', '    }\n', '\n', '    function swapPrecondition(address token) public view returns (bool) {\n', '        if (token == DGAS || token == WETH) return true;\n', '        uint256 percent = IDemaxConfig(CONFIG).getConfigValue(ConfigNames.TOKEN_TO_DGAS_PAIR_MIN_PERCENT);\n', '        if (!existPair(WETH, DGAS)) return false;\n', '        if (!existPair(DGAS, token)) return false;\n', '        if (!(IDemaxConfig(CONFIG).checkPair(DGAS, token) && IDemaxConfig(CONFIG).checkPair(WETH, token))) return false;\n', '        if (!existPair(WETH, token)) return true;\n', '        if (percent == 0) return true;\n', '        (uint256 reserveDGAS, ) = DemaxSwapLibrary.getReserves(FACTORY, DGAS, token);\n', '        (uint256 reserveWETH, ) = DemaxSwapLibrary.getReserves(FACTORY, WETH, token);\n', '        (uint256 reserveWETH2, uint256 reserveDGAS2) = DemaxSwapLibrary.getReserves(FACTORY, WETH, DGAS);\n', '        uint256 dgasValue = SafeMath.mul(reserveDGAS, reserveWETH2) / reserveDGAS2;\n', '        uint256 limitValue = SafeMath.mul(SafeMath.add(dgasValue, reserveWETH), percent) / PERCENT_DENOMINATOR;\n', '        return dgasValue >= limitValue;\n', '    }\n', '\n', '    function _swap(\n', '        uint256[] memory amounts,\n', '        address[] memory path,\n', '        address _to\n', '    ) internal {\n', "        require(swapPrecondition(path[path.length - 1]), 'DEMAX PLATFORM : CHECK DGAS/TOKEN TO VALUE FAIL');\n", '        for (uint256 i; i < path.length - 1; i++) {\n', '            (address input, address output) = (path[i], path[i + 1]);\n', "            require(swapPrecondition(input), 'DEMAX PLATFORM : CHECK DGAS/TOKEN VALUE FROM FAIL');\n", "            require(IDemaxConfig(CONFIG).checkPair(input, output), 'DEMAX PLATFORM : SWAP PAIR CONFIG CHECK FAIL');\n", '            (address token0, address token1) = DemaxSwapLibrary.sortTokens(input, output);\n', '            uint256 amountOut = amounts[i + 1];\n', '            (uint256 amount0Out, uint256 amount1Out) = input == token0\n', '                ? (uint256(0), amountOut)\n', '                : (amountOut, uint256(0));\n', '            address to = i < path.length - 2 ? DemaxSwapLibrary.pairFor(FACTORY, output, path[i + 2]) : _to;\n', '            IDemaxPair(DemaxSwapLibrary.pairFor(FACTORY, input, output)).swap(amount0Out, amount1Out, to, new bytes(0));\n', '            if (amount0Out > 0)\n', '                _transferNotify(DemaxSwapLibrary.pairFor(FACTORY, input, output), to, token0, amount0Out);\n', '            if (amount1Out > 0)\n', '                _transferNotify(DemaxSwapLibrary.pairFor(FACTORY, input, output), to, token1, amount1Out);\n', '        }\n', '        emit SwapToken(_to, path[0], path[path.length - 1], amounts[0], amounts[path.length - 1]);\n', '    }\n', '\n', '    function _swapFee(\n', '        uint256[] memory amounts,\n', '        address[] memory path,\n', '        uint256 percent\n', '    ) internal {\n', '        address[] memory feepath = new address[](2);\n', '        feepath[1] = DGAS;\n', '        for (uint256 i = 0; i < path.length - 1; i++) {\n', '            uint256 fee = SafeMath.mul(amounts[i], percent) / PERCENT_DENOMINATOR;\n', '            address input = path[i];\n', '            address output = path[i + 1];\n', '            address currentPair = DemaxSwapLibrary.pairFor(FACTORY, input, output);\n', '            if (input == DGAS) {\n', '                IDemaxPair(currentPair).swapFee(fee, DGAS, GOVERNANCE);\n', '                _transferNotify(currentPair, GOVERNANCE, DGAS, fee);\n', '            } else {\n', '                IDemaxPair(currentPair).swapFee(fee, input, DemaxSwapLibrary.pairFor(FACTORY, input, DGAS));\n', '                (uint256 reserveIn, uint256 reserveDGAS) = DemaxSwapLibrary.getReserves(FACTORY, input, DGAS);\n', '                uint256 feeOut = DemaxSwapLibrary.getAmountOut(fee, reserveIn, reserveDGAS);\n', '                IDemaxPair(DemaxSwapLibrary.pairFor(FACTORY, input, DGAS)).swapFee(feeOut, DGAS, GOVERNANCE);\n', '                _transferNotify(currentPair, DemaxSwapLibrary.pairFor(FACTORY, input, DGAS), input, fee);\n', '                _transferNotify(DemaxSwapLibrary.pairFor(FACTORY, input, DGAS), GOVERNANCE, DGAS, feeOut);\n', '                fee = feeOut;\n', '            }\n', '            if (fee > 0) IDemaxGovernance(GOVERNANCE).addReward(fee);\n', '        }\n', '    }\n', '\n', '    function _getSwapFeePercent() internal view returns (uint256) {\n', '        return IDemaxConfig(CONFIG).getConfigValue(ConfigNames.SWAP_FEE_PERCENT);\n', '    }\n', '\n', '    function swapExactTokensForTokens(\n', '        uint256 amountIn,\n', '        uint256 amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint256 deadline\n', '    ) external ensure(deadline) returns (uint256[] memory amounts) {\n', '        uint256 percent = _getSwapFeePercent();\n', '        amounts = _getAmountsOut(amountIn, path, percent);\n', "        require(amounts[amounts.length - 1] >= amountOutMin, 'DEMAX PLATFORM : INSUFFICIENT_OUTPUT_AMOUNT');\n", '        address pair = DemaxSwapLibrary.pairFor(FACTORY, path[0], path[1]);\n', '        _innerTransferFrom(\n', '            path[0],\n', '            msg.sender,\n', '            pair,\n', '            SafeMath.mul(amountIn, SafeMath.sub(PERCENT_DENOMINATOR, percent)) / PERCENT_DENOMINATOR\n', '        );\n', '        _swap(amounts, path, to);\n', '        _innerTransferFrom(path[0], msg.sender, pair, SafeMath.mul(amounts[0], percent) / PERCENT_DENOMINATOR);\n', '        _swapFee(amounts, path, percent);\n', '    }\n', '\n', '    function _innerTransferFrom(\n', '        address token,\n', '        address from,\n', '        address to,\n', '        uint256 amount\n', '    ) internal {\n', '        TransferHelper.safeTransferFrom(token, from, to, amount);\n', '        _transferNotify(from, to, token, amount);\n', '    }\n', '\n', '    function _innerTransferWETH(address to, uint256 amount) internal {\n', '        assert(IWETH(WETH).transfer(to, amount));\n', '        _transferNotify(address(this), to, WETH, amount);\n', '    }\n', '\n', '    function swapExactETHForTokens(\n', '        uint256 amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint256 deadline\n', '    ) external payable ensure(deadline) returns (uint256[] memory amounts) {\n', "        require(path[0] == WETH, 'DEMAX PLATFORM : INVALID_PATH');\n", '        uint256 percent = _getSwapFeePercent();\n', '        amounts = _getAmountsOut(msg.value, path, percent);\n', "        require(amounts[amounts.length - 1] >= amountOutMin, 'DEMAX PLATFORM : INSUFFICIENT_OUTPUT_AMOUNT');\n", '        address pair = DemaxSwapLibrary.pairFor(FACTORY, path[0], path[1]);\n', '        IWETH(WETH).deposit{\n', '            value: SafeMath.mul(amounts[0], SafeMath.sub(PERCENT_DENOMINATOR, percent)) / PERCENT_DENOMINATOR\n', '        }();\n', '        _innerTransferWETH(\n', '            pair,\n', '            SafeMath.mul(amounts[0], SafeMath.sub(PERCENT_DENOMINATOR, percent)) / PERCENT_DENOMINATOR\n', '        );\n', '        _swap(amounts, path, to);\n', '\n', '        IWETH(WETH).deposit{value: SafeMath.mul(amounts[0], percent) / PERCENT_DENOMINATOR}();\n', '        _innerTransferWETH(pair, SafeMath.mul(amounts[0], percent) / PERCENT_DENOMINATOR);\n', '        _swapFee(amounts, path, percent);\n', '    }\n', '\n', '    function swapExactTokensForETH(\n', '        uint256 amountIn,\n', '        uint256 amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint256 deadline\n', '    ) external ensure(deadline) returns (uint256[] memory amounts) {\n', "        require(path[path.length - 1] == WETH, 'DEMAX PLATFORM : INVALID_PATH');\n", '        uint256 percent = _getSwapFeePercent();\n', '        amounts = _getAmountsOut(amountIn, path, percent);\n', "        require(amounts[amounts.length - 1] >= amountOutMin, 'DEMAX PLATFORM : INSUFFICIENT_OUTPUT_AMOUNT');\n", '        address pair = DemaxSwapLibrary.pairFor(FACTORY, path[0], path[1]);\n', '        _innerTransferFrom(\n', '            path[0],\n', '            msg.sender,\n', '            pair,\n', '            SafeMath.mul(amountIn, SafeMath.sub(PERCENT_DENOMINATOR, percent)) / PERCENT_DENOMINATOR\n', '        );\n', '        _swap(amounts, path, address(this));\n', '        IWETH(WETH).withdraw(amounts[amounts.length - 1]);\n', '        TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);\n', '\n', '        _innerTransferFrom(path[0], msg.sender, pair, SafeMath.mul(amounts[0], percent) / PERCENT_DENOMINATOR);\n', '        _swapFee(amounts, path, percent);\n', '    }\n', '\n', '    function swapTokensForExactTokens(\n', '        uint256 amountOut,\n', '        uint256 amountInMax,\n', '        address[] calldata path,\n', '        address to,\n', '        uint256 deadline\n', '    ) external ensure(deadline) returns (uint256[] memory amounts) {\n', '        uint256 percent = _getSwapFeePercent();\n', '        amounts = _getAmountsIn(amountOut, path, percent);\n', "        require(amounts[0] <= amountInMax, 'DEMAX PLATFORM : EXCESSIVE_INPUT_AMOUNT');\n", '        address pair = DemaxSwapLibrary.pairFor(FACTORY, path[0], path[1]);\n', '\n', '        _innerTransferFrom(\n', '            path[0],\n', '            msg.sender,\n', '            pair,\n', '            SafeMath.mul(amounts[0], SafeMath.sub(PERCENT_DENOMINATOR, percent)) / PERCENT_DENOMINATOR\n', '        );\n', '        _swap(amounts, path, to);\n', '        _innerTransferFrom(path[0], msg.sender, pair, SafeMath.mul(amounts[0], percent) / PERCENT_DENOMINATOR);\n', '        _swapFee(amounts, path, percent);\n', '    }\n', '\n', '    function swapTokensForExactETH(\n', '        uint256 amountOut,\n', '        uint256 amountInMax,\n', '        address[] calldata path,\n', '        address to,\n', '        uint256 deadline\n', '    ) external ensure(deadline) returns (uint256[] memory amounts) {\n', "        require(path[path.length - 1] == WETH, 'DEMAX PLATFORM : INVALID_PATH');\n", '        uint256 percent = _getSwapFeePercent();\n', '        amounts = _getAmountsIn(amountOut, path, percent);\n', "        require(amounts[0] <= amountInMax, 'DEMAX PLATFORM : EXCESSIVE_INPUT_AMOUNT');\n", '        address pair = DemaxSwapLibrary.pairFor(FACTORY, path[0], path[1]);\n', '        _innerTransferFrom(\n', '            path[0],\n', '            msg.sender,\n', '            pair,\n', '            SafeMath.mul(amounts[0], SafeMath.sub(PERCENT_DENOMINATOR, percent)) / PERCENT_DENOMINATOR\n', '        );\n', '        _swap(amounts, path, address(this));\n', '        IWETH(WETH).withdraw(amounts[amounts.length - 1]);\n', '        TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);\n', '\n', '        _innerTransferFrom(path[0], msg.sender, pair, SafeMath.mul(amounts[0], percent) / PERCENT_DENOMINATOR);\n', '        _swapFee(amounts, path, percent);\n', '    }\n', '\n', '    function swapETHForExactTokens(\n', '        uint256 amountOut,\n', '        address[] calldata path,\n', '        address to,\n', '        uint256 deadline\n', '    ) external payable ensure(deadline) returns (uint256[] memory amounts) {\n', "        require(path[0] == WETH, 'DEMAX PLATFORM : INVALID_PATH');\n", '        uint256 percent = _getSwapFeePercent();\n', '        amounts = _getAmountsIn(amountOut, path, percent);\n', "        require(amounts[0] <= msg.value, 'DEMAX PLATFORM : EXCESSIVE_INPUT_AMOUNT');\n", '\n', '        IWETH(WETH).deposit{\n', '            value: SafeMath.mul(amounts[0], SafeMath.sub(PERCENT_DENOMINATOR, percent)) / PERCENT_DENOMINATOR\n', '        }();\n', '        address pair = DemaxSwapLibrary.pairFor(FACTORY, path[0], path[1]);\n', '        _innerTransferWETH(\n', '            pair,\n', '            SafeMath.mul(amounts[0], SafeMath.sub(PERCENT_DENOMINATOR, percent)) / PERCENT_DENOMINATOR\n', '        );\n', '        _swap(amounts, path, to);\n', '\n', '        IWETH(WETH).deposit{value: SafeMath.mul(amounts[0], percent) / PERCENT_DENOMINATOR}();\n', '        _innerTransferWETH(pair, SafeMath.mul(amounts[0], percent) / PERCENT_DENOMINATOR);\n', '        _swapFee(amounts, path, percent);\n', '        if (msg.value > amounts[0]) TransferHelper.safeTransferETH(msg.sender, msg.value - amounts[0]);\n', '    }\n', '\n', '    function _transferNotify(\n', '        address from,\n', '        address to,\n', '        address token,\n', '        uint256 amount\n', '    ) internal {\n', '        IDemaxTransferListener(TRANSFER_LISTENER).transferNotify(from, to, token, amount);\n', '    }\n', '\n', '    function existPair(address tokenA, address tokenB) public view returns (bool) {\n', '        return IDemaxFactory(FACTORY).getPair(tokenA, tokenB) != address(0);\n', '    }\n', '\n', '    function getReserves(address tokenA, address tokenB) public view returns (uint256, uint256) {\n', '        return DemaxSwapLibrary.getReserves(FACTORY, tokenA, tokenB);\n', '    }\n', '\n', '    function pairFor(address tokenA, address tokenB) public view returns (address) {\n', '        return DemaxSwapLibrary.pairFor(FACTORY, tokenA, tokenB);\n', '    }\n', '\n', '    function getAmountOut(\n', '        uint256 amountIn,\n', '        uint256 reserveIn,\n', '        uint256 reserveOut\n', '    ) public view returns (uint256 amountOut) {\n', '        uint256 percent = _getSwapFeePercent();\n', '        uint256 amount = SafeMath.mul(amountIn, SafeMath.sub(PERCENT_DENOMINATOR, percent)) / PERCENT_DENOMINATOR;\n', '        return DemaxSwapLibrary.getAmountOut(amount, reserveIn, reserveOut);\n', '    }\n', '\n', '    function getAmountIn(\n', '        uint256 amountOut,\n', '        uint256 reserveIn,\n', '        uint256 reserveOut\n', '    ) public view returns (uint256 amountIn) {\n', '        uint256 percent = _getSwapFeePercent();\n', '        uint256 amount = DemaxSwapLibrary.getAmountIn(amountOut, reserveIn, reserveOut);\n', '        return SafeMath.mul(amount, PERCENT_DENOMINATOR) / SafeMath.sub(PERCENT_DENOMINATOR, percent);\n', '    }\n', '\n', '    function getAmountsOut(uint256 amountIn, address[] memory path) public view returns (uint256[] memory amounts) {\n', '        uint256 percent = _getSwapFeePercent();\n', '        return _getAmountsOut(amountIn, path, percent);\n', '    }\n', '\n', '    function getAmountsIn(uint256 amountOut, address[] memory path) public view returns (uint256[] memory amounts) {\n', '        uint256 percent = _getSwapFeePercent();\n', '        return _getAmountsIn(amountOut, path, percent);\n', '    }\n', '}']