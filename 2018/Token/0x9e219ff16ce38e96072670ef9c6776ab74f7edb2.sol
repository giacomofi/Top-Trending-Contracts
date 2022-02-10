['pragma solidity ^0.4.24;\n', '\n', '// File: ../node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {\n', '    // Gas optimization: this is cheaper than asserting &#39;a&#39; not being zero, but the\n', '    // benefit is lost if &#39;b&#39; is also tested.\n', '    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '    if (_a == 0) {\n', '      return 0;\n', '    }\n', '\n', '    c = _a * _b;\n', '    assert(c / _a == _b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '    // assert(_b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = _a / _b;\n', '    // assert(_a == _b * c + _a % _b); // There is no case in which this doesn&#39;t hold\n', '    return _a / _b;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {\n', '    assert(_b <= _a);\n', '    return _a - _b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {\n', '    c = _a + _b;\n', '    assert(c >= _a);\n', '    return c;\n', '  }\n', '}\n', '\n', '// File: contracts/ETHReceiver.sol\n', '\n', 'contract ETHReceiver {\n', '    using SafeMath for *;\n', '\n', '    uint public balance_;\n', '    address public owner_;\n', '\n', '    event ReceivedValue(address indexed from, uint value);\n', '    event Withdraw(address indexed from, uint amount);\n', '    event ChangeOwner(address indexed from, address indexed to);\n', '\n', '    constructor ()\n', '        public\n', '    {\n', '        balance_ = 0;\n', '        owner_ = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner\n', '    {\n', '        require(msg.sender == owner_, "msg sender is not contract owner");\n', '        _;\n', '    }\n', '\n', '    function ()\n', '        public\n', '        payable\n', '    {\n', '        balance_ = (balance_).add(msg.value);\n', '        emit ReceivedValue(msg.sender, msg.value);\n', '    }\n', '\n', '    function transferTo (address _to, uint _amount)\n', '        public\n', '        onlyOwner()\n', '    {\n', '        _to.transfer(_amount);\n', '        balance_ = (balance_).sub(_amount);\n', '        emit Withdraw(_to, _amount);\n', '    }\n', '\n', '    function changeOwner (address _to)\n', '        public\n', '        onlyOwner()\n', '    {\n', '        assert(_to != address(0));\n', '        owner_ = _to;\n', '        emit ChangeOwner(msg.sender, _to);\n', '    }\n', '}']