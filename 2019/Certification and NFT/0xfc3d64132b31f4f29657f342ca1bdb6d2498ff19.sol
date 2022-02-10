['/**\n', ' * Copyright (c) 2019 blockimmo AG license@blockimmo.ch\n', ' * Non-Profit Open Software License 3.0 (NPOSL-3.0)\n', ' * https://opensource.org/licenses/NPOSL-3.0\n', ' */\n', '\n', 'pragma solidity ^0.5.2;\n', '\n', '/**\n', ' * @title Math\n', ' * @dev Assorted math operations\n', ' */\n', 'library Math {\n', '    /**\n', '    * @dev Returns the largest of two numbers.\n', '    */\n', '    function max(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a >= b ? a : b;\n', '    }\n', '\n', '    /**\n', '    * @dev Returns the smallest of two numbers.\n', '    */\n', '    function min(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a < b ? a : b;\n', '    }\n', '\n', '    /**\n', '    * @dev Calculates the average of two numbers. Since these are integers,\n', '    * averages of an even and odd number cannot be represented, and will be\n', '    * rounded down.\n', '    */\n', '    function average(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // (a + b) / 2 can overflow, so we distribute\n', '        return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);\n', '    }\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Unsigned math operations with safety checks that revert on error\n', ' */\n', 'library SafeMath {\n', '    /**\n', '    * @dev Multiplies two unsigned integers, reverts on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two unsigned integers, reverts on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),\n', '    * reverts when dividing by zero.\n', '    */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Secondary\n', ' * @dev A Secondary contract can only be used by its primary account (the one that created it)\n', ' */\n', 'contract Secondary {\n', '    address private _primary;\n', '\n', '    event PrimaryTransferred(\n', '        address recipient\n', '    );\n', '\n', '    /**\n', '     * @dev Sets the primary account to the one that is creating the Secondary contract.\n', '     */\n', '    constructor () internal {\n', '        _primary = msg.sender;\n', '        emit PrimaryTransferred(_primary);\n', '    }\n', '\n', '    /**\n', '     * @dev Reverts if called from any account other than the primary.\n', '     */\n', '    modifier onlyPrimary() {\n', '        require(msg.sender == _primary);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @return the address of the primary.\n', '     */\n', '    function primary() public view returns (address) {\n', '        return _primary;\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers contract to a new primary.\n', '     * @param recipient The address of new primary.\n', '     */\n', '    function transferPrimary(address recipient) public onlyPrimary {\n', '        require(recipient != address(0));\n', '        _primary = recipient;\n', '        emit PrimaryTransferred(_primary);\n', '    }\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'interface IERC20 {\n', '    function transfer(address to, uint256 value) external returns (bool);\n', '\n', '    function approve(address spender, uint256 value) external returns (bool);\n', '\n', '    function transferFrom(address from, address to, uint256 value) external returns (bool);\n', '\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    function balanceOf(address who) external view returns (uint256);\n', '\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title SafeERC20\n', ' * @dev Wrappers around ERC20 operations that throw on failure.\n', ' * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,\n', ' * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.\n', ' */\n', 'library SafeERC20 {\n', '    using SafeMath for uint256;\n', '\n', '    function safeTransfer(IERC20 token, address to, uint256 value) internal {\n', '        require(token.transfer(to, value));\n', '    }\n', '\n', '    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {\n', '        require(token.transferFrom(from, to, value));\n', '    }\n', '\n', '    function safeApprove(IERC20 token, address spender, uint256 value) internal {\n', '        // safeApprove should only be called when setting an initial allowance,\n', '        // or when resetting it to zero. To increase and decrease it, use\n', "        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'\n", '        require((value == 0) || (token.allowance(msg.sender, spender) == 0));\n', '        require(token.approve(spender, value));\n', '    }\n', '\n', '    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).add(value);\n', '        require(token.approve(spender, newAllowance));\n', '    }\n', '\n', '    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {\n', '        uint256 newAllowance = token.allowance(address(this), spender).sub(value);\n', '        require(token.approve(spender, newAllowance));\n', '    }\n', '}\n', '\n', 'contract MoneyMarketInterface {\n', '  function getSupplyBalance(address account, address asset) public view returns (uint);\n', '  function supply(address asset, uint amount) public returns (uint);\n', '  function withdraw(address asset, uint requestedAmount) public returns (uint);\n', '}\n', '\n', 'contract LoanEscrow is Secondary {\n', '  using SafeERC20 for IERC20;\n', '  using SafeMath for uint256;\n', '\n', '  address public constant DAI_ADDRESS = 0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359;  // 0x9Ad61E35f8309aF944136283157FABCc5AD371E5;\n', '  IERC20 public dai = IERC20(DAI_ADDRESS);\n', '\n', '  address public constant MONEY_MARKET_ADDRESS = 0x3FDA67f7583380E67ef93072294a7fAc882FD7E7;  // 0x6732c278C58FC90542cce498981844A073D693d7;\n', '  MoneyMarketInterface public moneyMarket = MoneyMarketInterface(MONEY_MARKET_ADDRESS);\n', '\n', '  event Deposited(address indexed from, uint256 daiAmount);\n', '  event Pulled(address indexed to, uint256 daiAmount);\n', '  event InterestWithdrawn(address indexed to, uint256 daiAmount);\n', '\n', '  mapping(address => uint256) public deposits;\n', '  mapping(address => uint256) public pulls;\n', '  uint256 public deposited;\n', '  uint256 public pulled;\n', '\n', '  function withdrawInterest() public onlyPrimary {\n', '    uint256 amountInterest = moneyMarket.getSupplyBalance(address(this), DAI_ADDRESS).sub(deposited).add(pulled);\n', '    require(amountInterest > 0, "no interest");\n', '\n', '    uint256 errorCode = moneyMarket.withdraw(DAI_ADDRESS, amountInterest);\n', '    require(errorCode == 0, "withdraw failed");\n', '\n', '    dai.safeTransfer(msg.sender, amountInterest);\n', '    emit InterestWithdrawn(msg.sender, amountInterest);\n', '  }\n', '\n', '  function deposit(address _from, uint256 _amountDai) internal {\n', '    require(_from != address(0) && _amountDai > 0, "invalid parameter(s)");\n', '    dai.safeTransferFrom(msg.sender, address(this), _amountDai);\n', '\n', '    require(dai.allowance(address(this), MONEY_MARKET_ADDRESS) == 0, "non-zero initial moneyMarket allowance");\n', '    require(dai.approve(MONEY_MARKET_ADDRESS, _amountDai), "approving moneyMarket failed");\n', '\n', '    uint256 errorCode = moneyMarket.supply(DAI_ADDRESS, _amountDai);\n', '    require(errorCode == 0, "supply failed");\n', '    require(dai.allowance(address(this), MONEY_MARKET_ADDRESS) == 0, "allowance not fully consumed by moneyMarket");\n', '\n', '    deposits[_from] = deposits[_from].add(_amountDai);\n', '    deposited = deposited.add(_amountDai);\n', '    emit Deposited(_from, _amountDai);\n', '  }\n', '\n', '  function pull(address _to, uint256 _amountDai, bool refund) internal {\n', '    uint256 errorCode = moneyMarket.withdraw(DAI_ADDRESS, _amountDai);\n', '    require(errorCode == 0, "withdraw failed");\n', '\n', '    if (refund) {\n', '      deposits[_to] = deposits[_to].sub(_amountDai);\n', '      deposited = deposited.sub(_amountDai);\n', '    } else {\n', '      pulls[_to] = pulls[_to].add(_amountDai);\n', '      pulled = pulled.add(_amountDai);\n', '    }\n', '\n', '    dai.safeTransfer(_to, _amountDai);\n', '    emit Pulled(_to, _amountDai);\n', '  }\n', '}\n', '\n', 'contract WhitelistInterface {\n', '  function hasRole(address _operator, string memory _role) public view returns (bool);\n', '}\n', '\n', 'contract WhitelistProxyInterface {\n', '  function whitelist() public view returns (WhitelistInterface);\n', '}\n', '\n', 'contract Exchange is LoanEscrow {\n', '  using SafeERC20 for IERC20;\n', '  using SafeMath for uint256;\n', '\n', '  uint256 public constant POINTS = uint256(10) ** 32;\n', '\n', '  address public constant WHITELIST_PROXY_ADDRESS = 0x77eb36579e77e6a4bcd2Ca923ada0705DE8b4114;  // 0xEC8bE1A5630364292E56D01129E8ee8A9578d7D8;\n', '  WhitelistProxyInterface public whitelistProxy = WhitelistProxyInterface(WHITELIST_PROXY_ADDRESS);\n', '\n', '  struct Order {\n', '    bool buy;\n', '    uint256 closingTime;\n', '    uint256 numberOfTokens;\n', '    uint256 numberOfDai;\n', '    IERC20 token;\n', '    address from;\n', '  }\n', '\n', '  mapping(bytes32 => Order) public orders;\n', '\n', '  event OrderDeleted(bytes32 indexed order);\n', '  event OrderFilled(bytes32 indexed order, uint256 numberOfTokens, uint256 numberOfDai, address indexed to);\n', '  event OrderPosted(bytes32 indexed order, bool indexed buy, uint256 closingTime, uint256 numberOfTokens, uint256 numberOfDai, IERC20 indexed token, address from);\n', '\n', '  function deleteOrder(bytes32 _hash) public {\n', '    Order memory o = orders[_hash];\n', '    require(o.from == msg.sender || !isValid(_hash));\n', '\n', '    if (o.buy)\n', '      pull(o.from, o.numberOfDai, true);\n', '\n', '    _deleteOrder(_hash);\n', '  }\n', '\n', '  function fillOrders(bytes32[] memory _hashes, address _from, uint256 numberOfTokens) public {\n', '    uint256 remainingTokens = numberOfTokens;\n', '    uint256 remainingDai = dai.allowance(msg.sender, address(this));\n', '\n', '    for (uint256 i = 0; i < _hashes.length; i++) {\n', '      bytes32 hash = _hashes[i];\n', '      require(isValid(hash), "invalid order");\n', '\n', '      Order memory o = orders[hash];\n', '\n', '      uint256 coefficient = (o.buy ? remainingTokens : remainingDai).mul(POINTS).div(o.buy ? o.numberOfTokens : o.numberOfDai);\n', '\n', '      uint256 nTokens = o.numberOfTokens.mul(Math.min(coefficient, POINTS)).div(POINTS);\n', '      uint256 vDai = o.numberOfDai.mul(Math.min(coefficient, POINTS)).div(POINTS);\n', '\n', '      o.buy ? remainingTokens -= nTokens : remainingDai -= vDai;\n', '      o.buy ? pull(_from, vDai, false) : dai.safeTransferFrom(msg.sender, o.from, vDai);\n', '      o.token.safeTransferFrom(o.buy ? _from : o.from, o.buy ? o.from : _from, nTokens);\n', '\n', '      emit OrderFilled(hash, nTokens, vDai, _from);\n', '      _deleteOrder(hash);\n', '\n', '      if (coefficient < POINTS)\n', '        _postOrder(o.buy, o.closingTime, o.numberOfTokens.sub(nTokens), o.numberOfDai.sub(vDai), o.token, o.from);\n', '    }\n', '\n', '    dai.safeTransferFrom(msg.sender, _from, remainingDai);\n', '    require(dai.allowance(msg.sender, address(this)) == 0);\n', '  }\n', '\n', '  function isValid(bytes32 _hash) public view returns (bool valid) {\n', '    Order memory o = orders[_hash];\n', '\n', '    valid = o.buy || (o.token.balanceOf(o.from) >= o.numberOfTokens && o.token.allowance(o.from, address(this)) >= o.numberOfTokens);\n', '    valid = valid && now <= o.closingTime && o.closingTime <= now.add(1 weeks);\n', '    valid = valid && o.numberOfTokens > 0 && o.numberOfDai > 0;\n', '    valid = valid && whitelistProxy.whitelist().hasRole(address(o.token), "authorized");\n', '  }\n', '\n', '  function postOrder(bool _buy, uint256 _closingTime, address _from, uint256 _numberOfTokens, uint256 _numberOfDai, IERC20 _token) public {\n', '    if (_buy)\n', '      deposit(_from, _numberOfDai);\n', '\n', '    _postOrder(_buy, _closingTime, _numberOfTokens, _numberOfDai, _token, _from);\n', '  }\n', '\n', '  function _deleteOrder(bytes32 _hash) internal {\n', '    delete orders[_hash];\n', '    emit OrderDeleted(_hash);\n', '  }\n', '\n', '  function _postOrder(bool _buy, uint256 _closingTime, uint256 _numberOfTokens, uint256 _numberOfDai, IERC20 _token, address _from) internal {\n', '    bytes32 hash = keccak256(abi.encodePacked(_buy, _closingTime, _numberOfTokens, _numberOfDai, _token, _from));\n', '    orders[hash] = Order(_buy, _closingTime, _numberOfTokens, _numberOfDai, _token, _from);\n', '\n', '    require(isValid(hash), "invalid order");\n', '    emit OrderPosted(hash, _buy, _closingTime, _numberOfTokens, _numberOfDai, _token, _from);\n', '  }\n', '}']