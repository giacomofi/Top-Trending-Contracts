['/**\n', ' *Submitted for verification at Etherscan.io on 2020-08-28\n', '*/\n', '\n', 'pragma solidity 0.4.24;\n', '\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a); \n', '    return c;\n', '  }\n', '}\n', 'contract ether2smart {\n', '    event Multisended(uint256 value , address sender);\n', '    using SafeMath for uint256;\n', '\n', '    function multisendEther(address[] _contributors, uint256[] _balances) public payable {\n', '        uint256 total = msg.value;\n', '        uint256 i = 0;\n', '        for (i; i < _contributors.length; i++) {\n', '            require(total >= _balances[i] );\n', '            total = total.sub(_balances[i]);\n', '            _contributors[i].transfer(_balances[i]);\n', '        }\n', '        emit Multisended(msg.value, msg.sender);\n', '    }\n', '}']