['pragma solidity ^0.4.16;\n', '\n', '/**\n', ' * The Owned contract ensures that only the creator (deployer) of a \n', ' * contract can perform certain tasks.\n', ' */\n', 'contract Owned {\n', '    address public owner = msg.sender;\n', '    event OwnerChanged(address indexed old, address indexed current);\n', '    modifier only_owner { require(msg.sender == owner); _; }\n', '    function setOwner(address _newOwner) only_owner public { emit OwnerChanged(owner, _newOwner); owner = _newOwner; }\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '    \n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '  \n', '}\n', '\n', 'contract DepositTiken is Owned {\n', '    \n', '    using SafeMath for uint;\n', '    \n', '    uint public _money = 0;\n', '//  uint public _moneySystem = 0;\n', '    uint public _tokens = 0;\n', '    uint public _sellprice = 10**18;\n', '    uint public contractBalance;\n', '    \n', '    // сохранить баланс на счетах пользователя\n', '    \n', '    mapping (address => uint) balances;\n', '    \n', '    event SomeEvent(address indexed from, address indexed to, uint value, bytes32 status);\n', '    constructor () public {\n', '        uint s = 10**18;\n', '        _sellprice = s.mul(95).div(100);\n', '    }\n', '    function balanceOf(address addr) public constant returns(uint){\n', '        return balances[addr];\n', '    }\n', '    function balance() public constant returns(uint){\n', '        return balances[msg.sender];\n', '    }\n', '    // OK\n', '    function buy() external payable {\n', '        uint _value = msg.value.mul(10**18).div(_sellprice.mul(100).div(95));\n', '        \n', '        _money += msg.value.mul(97).div(100);\n', '        //_moneySystem += msg.value.mul(3).div(100);\n', '        \n', '        owner.transfer(msg.value.mul(3).div(100));\n', '        \n', '        _tokens += _value;\n', '        balances[msg.sender] += _value;\n', '        \n', '        _sellprice = _money.mul(10**18).mul(99).div(_tokens).div(100);\n', '        \n', '        address _this = this;\n', '        contractBalance = _this.balance;\n', '        \n', '        emit SomeEvent(msg.sender, this, _value, "buy");\n', '    }\n', '    \n', '    function sell (uint256 countTokens) public {\n', '        require(balances[msg.sender] - countTokens >= 0);\n', '        \n', '        uint _value = countTokens.mul(_sellprice).div(10**18);\n', '        \n', '        _money -= _value;\n', '        \n', '        _tokens -= countTokens;\n', '        balances[msg.sender] -= countTokens;\n', '        \n', '        if(_tokens > 0) {\n', '            _sellprice = _money.mul(10**18).mul(99).div(_tokens).div(100);\n', '        }\n', '        \n', '        address _this = this;\n', '        contractBalance = _this.balance;\n', '        \n', '        msg.sender.transfer(_value);\n', '        \n', '        emit SomeEvent(msg.sender, this, _value, "sell");\n', '    }\n', '    function getPrice() public constant returns (uint bid, uint ask) {\n', '        bid = _sellprice.mul(100).div(95);\n', '        ask = _sellprice;\n', '    }\n', '}']
['pragma solidity ^0.4.16;\n', '\n', '/**\n', ' * The Owned contract ensures that only the creator (deployer) of a \n', ' * contract can perform certain tasks.\n', ' */\n', 'contract Owned {\n', '    address public owner = msg.sender;\n', '    event OwnerChanged(address indexed old, address indexed current);\n', '    modifier only_owner { require(msg.sender == owner); _; }\n', '    function setOwner(address _newOwner) only_owner public { emit OwnerChanged(owner, _newOwner); owner = _newOwner; }\n', '}\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '    \n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '  \n', '}\n', '\n', 'contract DepositTiken is Owned {\n', '    \n', '    using SafeMath for uint;\n', '    \n', '    uint public _money = 0;\n', '//  uint public _moneySystem = 0;\n', '    uint public _tokens = 0;\n', '    uint public _sellprice = 10**18;\n', '    uint public contractBalance;\n', '    \n', '    // сохранить баланс на счетах пользователя\n', '    \n', '    mapping (address => uint) balances;\n', '    \n', '    event SomeEvent(address indexed from, address indexed to, uint value, bytes32 status);\n', '    constructor () public {\n', '        uint s = 10**18;\n', '        _sellprice = s.mul(95).div(100);\n', '    }\n', '    function balanceOf(address addr) public constant returns(uint){\n', '        return balances[addr];\n', '    }\n', '    function balance() public constant returns(uint){\n', '        return balances[msg.sender];\n', '    }\n', '    // OK\n', '    function buy() external payable {\n', '        uint _value = msg.value.mul(10**18).div(_sellprice.mul(100).div(95));\n', '        \n', '        _money += msg.value.mul(97).div(100);\n', '        //_moneySystem += msg.value.mul(3).div(100);\n', '        \n', '        owner.transfer(msg.value.mul(3).div(100));\n', '        \n', '        _tokens += _value;\n', '        balances[msg.sender] += _value;\n', '        \n', '        _sellprice = _money.mul(10**18).mul(99).div(_tokens).div(100);\n', '        \n', '        address _this = this;\n', '        contractBalance = _this.balance;\n', '        \n', '        emit SomeEvent(msg.sender, this, _value, "buy");\n', '    }\n', '    \n', '    function sell (uint256 countTokens) public {\n', '        require(balances[msg.sender] - countTokens >= 0);\n', '        \n', '        uint _value = countTokens.mul(_sellprice).div(10**18);\n', '        \n', '        _money -= _value;\n', '        \n', '        _tokens -= countTokens;\n', '        balances[msg.sender] -= countTokens;\n', '        \n', '        if(_tokens > 0) {\n', '            _sellprice = _money.mul(10**18).mul(99).div(_tokens).div(100);\n', '        }\n', '        \n', '        address _this = this;\n', '        contractBalance = _this.balance;\n', '        \n', '        msg.sender.transfer(_value);\n', '        \n', '        emit SomeEvent(msg.sender, this, _value, "sell");\n', '    }\n', '    function getPrice() public constant returns (uint bid, uint ask) {\n', '        bid = _sellprice.mul(100).div(95);\n', '        ask = _sellprice;\n', '    }\n', '}']