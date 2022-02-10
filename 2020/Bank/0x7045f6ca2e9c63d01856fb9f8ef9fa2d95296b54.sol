['pragma solidity ^0.6.4;\n', '\n', 'interface IERC20 {\n', '    event Approval(address indexed _src, address indexed _dst, uint _amount);\n', '    event Transfer(address indexed _src, address indexed _dst, uint _amount);\n', '\n', '    function totalSupply() external view returns (uint);\n', '    function balanceOf(address _whom) external view returns (uint);\n', '    function allowance(address _src, address _dst) external view returns (uint);\n', '\n', '    function approve(address _dst, uint _amount) external returns (bool);\n', '    function transfer(address _dst, uint _amount) external returns (bool);\n', '    function transferFrom(\n', '        address _src, address _dst, uint _amount\n', '    ) external returns (bool);\n', '}\n', '// File: @emilianobonassi/gas-saver/ChiGasSaver.sol\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', 'interface IFreeFromUpTo {\n', '    function freeFromUpTo(address from, uint256 value) external returns(uint256 freed);\n', '}\n', '\n', 'contract ChiGasSaver {\n', '\n', '    modifier saveGas(address payable sponsor) {\n', '        uint256 gasStart = gasleft();\n', '        _;\n', '        uint256 gasSpent = 21000 + gasStart - gasleft() + 16 * msg.data.length;\n', '\n', '        IFreeFromUpTo chi = IFreeFromUpTo(0x0000000000004946c0e9F43F4Dee607b0eF1fA1c);\n', '        chi.freeFromUpTo(sponsor, (gasSpent + 14154) / 41947);\n', '    }\n', '}\n', '\n', '// File: localhost/contracts/Ownable.sol\n', '\n', 'pragma solidity 0.6.4;\n', '\n', '// TODO move this generic contract to a seperate repo with all generic smart contracts\n', '\n', 'contract Ownable {\n', '\n', '    bytes32 constant public oSlot = keccak256("Ownable.storage.location");\n', '\n', '    event OwnerChanged(address indexed previousOwner, address indexed newOwner);\n', '\n', '    // Ownable struct\n', '    struct os {\n', '        address owner;\n', '    }\n', '\n', '    modifier onlyOwner(){\n', '        require(msg.sender == los().owner, "Ownable.onlyOwner: msg.sender not owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '        @notice Transfer ownership to a new address\n', '        @param _newOwner Address of the new owner\n', '    */\n', '    function transferOwnership(address _newOwner) onlyOwner external {\n', '        _setOwner(_newOwner);\n', '    }\n', '\n', '    /**\n', '        @notice Internal method to set the owner\n', '        @param _newOwner Address of the new owner\n', '    */\n', '    function _setOwner(address _newOwner) internal {\n', '        emit OwnerChanged(los().owner, _newOwner);\n', '        los().owner = _newOwner;\n', '    }\n', '\n', '    /**\n', '        @notice Load ownable storage\n', '        @return s Storage pointer to the Ownable storage struct\n', '    */\n', '    function los() internal pure returns (os storage s) {\n', '        bytes32 loc = oSlot;\n', '        assembly {\n', '            s_slot := loc\n', '        }\n', '    }\n', '\n', '}\n', '// File: localhost/contracts/interfaces/ISmartPoolRegistry.sol\n', '\n', 'pragma solidity 0.6.4;\n', '\n', 'interface ISmartPoolRegistry {\n', '    function inRegistry(address _pool) external view returns(bool);\n', '    function entries(uint256 _index) external view returns(address);\n', '    function addSmartPool(address _smartPool) external;\n', '    function removeSmartPool(uint256 _index) external;\n', '}\n', '// File: localhost/contracts/interfaces/IUniswapV2Exchange.sol\n', '\n', 'interface IUniswapV2Exchange {\n', '    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;\n', '    function token0() external view returns (address);\n', '    function token1() external view returns (address);\n', '    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);\n', '}\n', '// File: localhost/contracts/interfaces/IUniswapV2Factory.sol\n', '\n', 'interface IUniswapV2Factory {\n', '    function getPair(address tokenA, address tokenB) external view returns (address pair);\n', '}\n', '// File: localhost/contracts/interfaces/IPSmartPool.sol\n', '\n', 'pragma solidity ^0.6.4;\n', '\n', 'interface IPSmartPool is IERC20 {\n', '    function joinPool(uint256 _amount) external;\n', '    function exitPool(uint256 _amount) external;\n', '    function getController() external view returns(address);\n', '    function getTokens() external view returns(address[] memory);\n', '    function calcTokensForAmount(uint256 _amount) external view  returns(address[] memory tokens, uint256[] memory amounts);\n', '}\n', '// File: localhost/contracts/recipes/LibSafeApproval.sol\n', '\n', '\n', '\n', 'library LibSafeApprove {\n', '    function safeApprove(IERC20 _token, address _spender, uint256 _amount) internal {\n', '        uint256 currentAllowance = _token.allowance(address(this), _spender);\n', '\n', '        // Do nothing if allowance is already set to this value\n', '        if(currentAllowance == _amount) {\n', '            return;\n', '        }\n', '\n', '        // If approval is not zero reset it to zero first\n', '        if(currentAllowance != 0) {\n', '            _token.approve(_spender, 0);\n', '        }\n', '\n', '        // do the actual approval\n', '        _token.approve(_spender, _amount);\n', '    }\n', '}\n', '// File: localhost/contracts/recipes/SafeMath.sol\n', '\n', '\n', '// a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)\n', '\n', 'library SafeMath {\n', '    function add(uint x, uint y) internal pure returns (uint z) {\n', "        require((z = x + y) >= x, 'ds-math-add-overflow');\n", '    }\n', '\n', '    function sub(uint x, uint y) internal pure returns (uint z) {\n', "        require((z = x - y) <= x, 'ds-math-sub-underflow');\n", '    }\n', '\n', '    function mul(uint x, uint y) internal pure returns (uint z) {\n', "        require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');\n", '    }\n', '}\n', '// File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol\n', '\n', 'pragma solidity >=0.5.0;\n', '\n', 'interface IUniswapV2Pair {\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '\n', '    function name() external pure returns (string memory);\n', '    function symbol() external pure returns (string memory);\n', '    function decimals() external pure returns (uint8);\n', '    function totalSupply() external view returns (uint);\n', '    function balanceOf(address owner) external view returns (uint);\n', '    function allowance(address owner, address spender) external view returns (uint);\n', '\n', '    function approve(address spender, uint value) external returns (bool);\n', '    function transfer(address to, uint value) external returns (bool);\n', '    function transferFrom(address from, address to, uint value) external returns (bool);\n', '\n', '    function DOMAIN_SEPARATOR() external view returns (bytes32);\n', '    function PERMIT_TYPEHASH() external pure returns (bytes32);\n', '    function nonces(address owner) external view returns (uint);\n', '\n', '    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;\n', '\n', '    event Mint(address indexed sender, uint amount0, uint amount1);\n', '    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);\n', '    event Swap(\n', '        address indexed sender,\n', '        uint amount0In,\n', '        uint amount1In,\n', '        uint amount0Out,\n', '        uint amount1Out,\n', '        address indexed to\n', '    );\n', '    event Sync(uint112 reserve0, uint112 reserve1);\n', '\n', '    function MINIMUM_LIQUIDITY() external pure returns (uint);\n', '    function factory() external view returns (address);\n', '    function token0() external view returns (address);\n', '    function token1() external view returns (address);\n', '    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);\n', '    function price0CumulativeLast() external view returns (uint);\n', '    function price1CumulativeLast() external view returns (uint);\n', '    function kLast() external view returns (uint);\n', '\n', '    function mint(address to) external returns (uint liquidity);\n', '    function burn(address to) external returns (uint amount0, uint amount1);\n', '    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;\n', '    function skim(address to) external;\n', '    function sync() external;\n', '\n', '    function initialize(address, address) external;\n', '}\n', '\n', '// File: localhost/contracts/recipes/UniswapV2Library.sol\n', '\n', 'pragma solidity >=0.5.0;\n', '\n', '\n', '\n', 'library UniLib {\n', '    using SafeMath for uint;\n', '\n', '    // returns sorted token addresses, used to handle return values from pairs sorted in this order\n', '    function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {\n', "        require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');\n", '        (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);\n', "        require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');\n", '    }\n', '\n', '    // calculates the CREATE2 address for a pair without making any external calls\n', '    function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {\n', '        (address token0, address token1) = sortTokens(tokenA, tokenB);\n', '        pair = address(uint(keccak256(abi.encodePacked(\n', "                hex'ff',\n", '                factory,\n', '                keccak256(abi.encodePacked(token0, token1)),\n', "                hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f' // init code hash\n", '            ))));\n', '    }\n', '\n', '    // fetches and sorts the reserves for a pair\n', '    function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {\n', '        (address token0,) = sortTokens(tokenA, tokenB);\n', '        (uint reserve0, uint reserve1,) = IUniswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();\n', '        (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);\n', '    }\n', '\n', '    // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset\n', '    function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {\n', "        require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');\n", "        require(reserveA > 0 && reserveB > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');\n", '        amountB = amountA.mul(reserveB) / reserveA;\n', '    }\n', '\n', '    // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset\n', '    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {\n', "        require(amountIn > 0, 'UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT');\n", "        require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');\n", '        uint amountInWithFee = amountIn.mul(997);\n', '        uint numerator = amountInWithFee.mul(reserveOut);\n', '        uint denominator = reserveIn.mul(1000).add(amountInWithFee);\n', '        amountOut = numerator / denominator;\n', '    }\n', '\n', '    // given an output amount of an asset and pair reserves, returns a required input amount of the other asset\n', '    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {\n', "        require(amountOut > 0, 'UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');\n", "        require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');\n", '        uint numerator = reserveIn.mul(amountOut).mul(1000);\n', '        uint denominator = reserveOut.sub(amountOut).mul(997);\n', '        amountIn = (numerator / denominator).add(1);\n', '    }\n', '\n', '    // performs chained getAmountOut calculations on any number of pairs\n', '    function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {\n', "        require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');\n", '        amounts = new uint[](path.length);\n', '        amounts[0] = amountIn;\n', '        for (uint i; i < path.length - 1; i++) {\n', '            (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);\n', '            amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);\n', '        }\n', '    }\n', '\n', '    // performs chained getAmountIn calculations on any number of pairs\n', '    function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {\n', "        require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');\n", '        amounts = new uint[](path.length);\n', '        amounts[amounts.length - 1] = amountOut;\n', '        for (uint i = path.length - 1; i > 0; i--) {\n', '            (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);\n', '            amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);\n', '        }\n', '    }\n', '}\n', '// File: localhost/contracts/interfaces/IERC20.sol\n', '\n', '\n', '// File: localhost/contracts/interfaces/IWETH.sol\n', '\n', '\n', '\n', 'interface IWETH is IERC20 {\n', '    function deposit() external payable;\n', '    function withdraw(uint wad) external;\n', '}\n', '// File: localhost/contracts/recipes/UniswapV2Recipe.sol\n', '\n', 'pragma solidity 0.6.4;\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', 'contract UniswapV2Recipe is Ownable, ChiGasSaver {\n', '    using LibSafeApprove for IERC20;\n', '\n', '    IWETH public WETH;\n', '    IUniswapV2Factory public uniswapFactory;\n', '    ISmartPoolRegistry public registry;\n', '    address payable gasSponsor;\n', '\n', '    constructor(address _WETH, address _uniswapFactory, address _registry) public {\n', '        WETH = IWETH(_WETH);\n', '        uniswapFactory = IUniswapV2Factory(_uniswapFactory);\n', '        registry = ISmartPoolRegistry(_registry);\n', '        _setOwner(msg.sender);\n', '        gasSponsor = 0x3bFdA5285416eB06Ebc8bc0aBf7d105813af06d0;\n', '    }\n', '\n', '    // Max eth amount enforced by msg.value\n', '    function toPie(address _pie, uint256 _poolAmount) external payable saveGas(gasSponsor) {\n', '        uint256 totalEth = calcToPie(_pie, _poolAmount);\n', '        require(msg.value >= totalEth, "Amount ETH too low");\n', '\n', '        WETH.deposit{value: totalEth}();\n', '\n', '        _toPie(_pie, _poolAmount);\n', '\n', '        // return excess ETH\n', '        if(address(this).balance != 0) {\n', '            // Send any excess ETH back\n', '            msg.sender.transfer(address(this).balance);\n', '        }\n', '\n', '        // Transfer pool tokens to msg.sender\n', '        IERC20 pie = IERC20(_pie);\n', '\n', '        IERC20(pie).transfer(msg.sender, pie.balanceOf(address(this)));\n', '    }\n', '\n', '    function _toPie(address _pie, uint256 _poolAmount) internal {\n', '        (address[] memory tokens, uint256[] memory amounts) = IPSmartPool(_pie).calcTokensForAmount(_poolAmount);\n', '\n', '        for(uint256 i = 0; i < tokens.length; i++) {\n', '            if(registry.inRegistry(tokens[i])) {\n', '                _toPie(tokens[i], amounts[i]);\n', '            } else {\n', '                IUniswapV2Exchange pair = IUniswapV2Exchange(uniswapFactory.getPair(tokens[i], address(WETH)));\n', '\n', '                (uint256 reserveA, uint256 reserveB) = UniLib.getReserves(address(uniswapFactory), address(WETH), tokens[i]);\n', '                uint256 amountIn = UniLib.getAmountIn(amounts[i], reserveA, reserveB);\n', '\n', '                // UniswapV2 does not pull the token\n', '                WETH.transfer(address(pair), amountIn);\n', '\n', '                if(token0Or1(address(pair), tokens[i]) == 0) {\n', '                    pair.swap(amounts[i], 0, address(this), new bytes(0));\n', '                } else {\n', '                    pair.swap(0, amounts[i], address(this), new bytes(0));\n', '                }\n', '            }\n', '\n', '            IERC20(tokens[i]).safeApprove(_pie, amounts[i]);\n', '        }\n', '\n', '        IPSmartPool pie = IPSmartPool(_pie);\n', '        pie.joinPool(_poolAmount);\n', '    }\n', '\n', '    function calcToPie(address _pie, uint256 _poolAmount) public view returns(uint256) {\n', '        (address[] memory tokens, uint256[] memory amounts) = IPSmartPool(_pie).calcTokensForAmount(_poolAmount);\n', '\n', '        uint256 totalEth = 0;\n', '\n', '        for(uint256 i = 0; i < tokens.length; i++) {\n', '            if(registry.inRegistry(tokens[i])) {\n', '                totalEth += calcToPie(tokens[i], amounts[i]);\n', '            } else {\n', '                (uint256 reserveA, uint256 reserveB) = UniLib.getReserves(address(uniswapFactory), address(WETH), tokens[i]);\n', '                totalEth += UniLib.getAmountIn(amounts[i], reserveA, reserveB);\n', '            }\n', '        }\n', '\n', '        return totalEth;\n', '    }\n', '\n', '\n', '    // TODO recursive exit\n', '    function toEth(address _pie, uint256 _poolAmount, uint256 _minEthAmount) external saveGas(gasSponsor) {\n', '        uint256 totalEth = calcToPie(_pie, _poolAmount);\n', '        require(_minEthAmount <= totalEth, "Output ETH amount too low");\n', '        IPSmartPool pie = IPSmartPool(_pie);\n', '\n', '        (address[] memory tokens, uint256[] memory amounts) = IPSmartPool(_pie).calcTokensForAmount(_poolAmount);\n', '        pie.transferFrom(msg.sender, address(this), _poolAmount);\n', '        pie.exitPool(_poolAmount);\n', '\n', '        for(uint256 i = 0; i < tokens.length; i++) {\n', '            (uint256 reserveA, uint256 reserveB) = UniLib.getReserves(address(uniswapFactory), tokens[i], address(WETH));\n', '            uint256 wethAmountOut = UniLib.getAmountOut(amounts[i], reserveA, reserveB);\n', '            IUniswapV2Exchange pair = IUniswapV2Exchange(uniswapFactory.getPair(tokens[i], address(WETH)));\n', '\n', '            // Uniswap V2 does not pull the token\n', '            IERC20(tokens[i]).transfer(address(pair), amounts[i]);\n', '\n', '            if(token0Or1(address(pair), tokens[i]) == 0) {\n', '                pair.swap(0, wethAmountOut, address(this), new bytes(0));\n', '            } else {\n', '                pair.swap(wethAmountOut, 0, address(this), new bytes(0));\n', '            }\n', '        }\n', '\n', '        WETH.withdraw(totalEth);\n', '        msg.sender.transfer(address(this).balance);\n', '    }\n', '\n', '    function calcToEth(address _pie, uint256 _poolAmountOut) external view returns(uint256) {\n', '        (address[] memory tokens, uint256[] memory amounts) = IPSmartPool(_pie).calcTokensForAmount(_poolAmountOut);\n', '\n', '        uint256 totalEth = 0;\n', '\n', '        for(uint256 i = 0; i < tokens.length; i++) {\n', '            (uint256 reserveA, uint256 reserveB) = UniLib.getReserves(address(uniswapFactory), tokens[i], address(WETH));\n', '            totalEth += UniLib.getAmountOut(amounts[i], reserveA, reserveB);\n', '        }\n', '\n', '        return totalEth;\n', '    }\n', '\n', '    function token0Or1(address _pair, address _token) internal view returns(uint256) {\n', '        IUniswapV2Exchange pair = IUniswapV2Exchange(_pair);\n', '\n', '        if(pair.token0() == _token) {\n', '            return 0;\n', '        }\n', '\n', '        return 1;\n', '    }\n', '\n', '    function saveEth() external onlyOwner {\n', '        msg.sender.transfer(address(this).balance);\n', '    }\n', '\n', '    function saveToken(address _token) external onlyOwner {\n', '        IERC20 token = IERC20(_token);\n', '        token.transfer(msg.sender, token.balanceOf(address(this)));\n', '    }\n', '\n', '}']