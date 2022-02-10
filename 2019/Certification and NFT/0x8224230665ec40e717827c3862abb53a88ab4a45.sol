['/**\n', ' * Copyright (c) 2019 STX AG license@stx.swiss\n', ' * No license\n', ' */\n', '\n', 'pragma solidity 0.5.3;\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'interface IERC20 {\n', '    function transfer(address to, uint256 value) external returns (bool);\n', '\n', '    function approve(address spender, uint256 value) external returns (bool);\n', '\n', '    function transferFrom(address from, address to, uint256 value) external returns (bool);\n', '\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    function balanceOf(address who) external view returns (uint256);\n', '\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Unsigned math operations with safety checks that revert on error\n', ' */\n', 'library SafeMath {\n', '    /**\n', '    * @dev Multiplies two unsigned integers, reverts on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two unsigned integers, reverts on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),\n', '    * reverts when dividing by zero.\n', '    */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title SafeERC20\n', ' * @dev Wrappers around ERC20 operations that throw on failure.\n', ' * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,\n', ' * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.\n', ' */\n', 'library SafeERC20 {\n', '    using SafeMath for uint256;\n', '\n', '    function safeTransfer(IERC20 token, address to, uint256 value) internal {\n', '        require(token.transfer(to, value));\n', '    }\n', '\n', '    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {\n', '        require(token.transferFrom(from, to, value));\n', '    }\n', '\n', '    function safeApprove(IERC20 token, address spender, uint256 value) internal {\n', '        // safeApprove should only be called when setting an initial allowance,\n', '        // or when resetting it to zero. To increase and decrease it, use\n', "        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'\n", '        require((value == 0) || (token.allowance(msg.sender, spender) == 0));\n', '        require(token.approve(spender, value));\n', '    }\n', '\n', '    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).add(value);\n', '        require(token.approve(spender, newAllowance));\n', '    }\n', '\n', '    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).sub(value);\n', '        require(token.approve(spender, newAllowance));\n', '    }\n', '}\n', '\n', 'contract KyberNetworkProxyInterface {\n', '  function swapEtherToToken(IERC20 token, uint minConversionRate) public payable returns (uint);\n', '  function swapTokenToToken(IERC20 src, uint srcAmount, IERC20 dest, uint minConversionRate) public returns (uint);\n', '}\n', '\n', 'contract PaymentsLayer {\n', '  using SafeERC20 for IERC20;\n', '  using SafeMath for uint256;\n', '\n', '  address public constant DAI_ADDRESS = 0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359;  // 0x9Ad61E35f8309aF944136283157FABCc5AD371E5;\n', '  IERC20 public dai = IERC20(DAI_ADDRESS);\n', '\n', '  address public constant ETH_TOKEN_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;\n', '\n', '  event PaymentForwarded(address indexed from, address indexed to, address indexed srcToken, uint256 amountDai, uint256 amountSrc, uint256 changeDai, bytes encodedFunctionCall);\n', '\n', '  function forwardEth(KyberNetworkProxyInterface _kyberNetworkProxy, IERC20 _srcToken, uint256 _minimumRate, address _destinationAddress, bytes memory _encodedFunctionCall) public payable {\n', '    require(address(_srcToken) != address(0) && _minimumRate > 0 && _destinationAddress != address(0), "invalid parameter(s)");\n', '\n', '    uint256 srcQuantity = address(_srcToken) == ETH_TOKEN_ADDRESS ? msg.value : _srcToken.allowance(msg.sender, address(this));\n', '\n', '    if (address(_srcToken) != ETH_TOKEN_ADDRESS) {\n', '      _srcToken.safeTransferFrom(msg.sender, address(this), srcQuantity);\n', '\n', '      require(_srcToken.allowance(address(this), address(_kyberNetworkProxy)) == 0, "non-zero initial _kyberNetworkProxy allowance");\n', '      require(_srcToken.approve(address(_kyberNetworkProxy), srcQuantity), "approving _kyberNetworkProxy failed");\n', '    }\n', '\n', '    uint256 amountDai = address(_srcToken) == ETH_TOKEN_ADDRESS ? _kyberNetworkProxy.swapEtherToToken.value(srcQuantity)(dai, _minimumRate) : _kyberNetworkProxy.swapTokenToToken(_srcToken, srcQuantity, dai, _minimumRate);\n', '    require(amountDai >= srcQuantity.mul(_minimumRate).div(1e18), "_kyberNetworkProxy failed");\n', '\n', '    require(dai.allowance(address(this), _destinationAddress) == 0, "non-zero initial destination allowance");\n', '    require(dai.approve(_destinationAddress, amountDai), "approving destination failed");\n', '\n', '    (bool success, ) = _destinationAddress.call(_encodedFunctionCall);\n', '    require(success, "destination call failed");\n', '\n', '    uint256 changeDai = dai.allowance(address(this), _destinationAddress);\n', '    if (changeDai > 0) {\n', '      dai.safeTransfer(msg.sender, changeDai);\n', '      require(dai.approve(_destinationAddress, 0), "un-approving destination failed");\n', '    }\n', '\n', '    emit PaymentForwarded(msg.sender, _destinationAddress, address(_srcToken), amountDai.sub(changeDai), srcQuantity, changeDai, _encodedFunctionCall);\n', '  }\n', '}']