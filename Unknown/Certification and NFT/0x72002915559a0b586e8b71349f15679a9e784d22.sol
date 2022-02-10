['pragma solidity ^0.4.11;\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control \n', ' * functions, this simplifies the implementation of "user permissions". \n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  /** \n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() {\n', '    owner = "0x1428452bff9f56D194F63d910cb16E745b9ee048";\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner. \n', '   */\n', '  modifier onlyOwner() {\n', '    if (msg.sender != owner) {\n', '      throw;\n', '    }\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to. \n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner {\n', '    if (newOwner != address(0)) {\n', '      owner = newOwner;\n', '    }\n', '  }\n', '\n', '}\n', '\n', 'contract Token{\n', '  function transfer(address to, uint value) returns (bool);\n', '}\n', '\n', 'contract Indorser is Ownable {\n', '\n', '    function multisend(address _tokenAddr, address[] _to, uint256[] _value)\n', '    returns (bool _success) {\n', '        assert(_to.length == _value.length);\n', '\t\tassert(_to.length <= 150);\n', '        // loop through to addresses and send value\n', '\t\tfor (uint8 i = 0; i < _to.length; i++) {\n', '            assert((Token(_tokenAddr).transfer(_to[i], _value[i])) == true);\n', '        }\n', '        return true;\n', '    }\n', '}']
['pragma solidity ^0.4.11;\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control \n', ' * functions, this simplifies the implementation of "user permissions". \n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  /** \n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() {\n', '    owner = "0x1428452bff9f56D194F63d910cb16E745b9ee048";\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner. \n', '   */\n', '  modifier onlyOwner() {\n', '    if (msg.sender != owner) {\n', '      throw;\n', '    }\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to. \n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner {\n', '    if (newOwner != address(0)) {\n', '      owner = newOwner;\n', '    }\n', '  }\n', '\n', '}\n', '\n', 'contract Token{\n', '  function transfer(address to, uint value) returns (bool);\n', '}\n', '\n', 'contract Indorser is Ownable {\n', '\n', '    function multisend(address _tokenAddr, address[] _to, uint256[] _value)\n', '    returns (bool _success) {\n', '        assert(_to.length == _value.length);\n', '\t\tassert(_to.length <= 150);\n', '        // loop through to addresses and send value\n', '\t\tfor (uint8 i = 0; i < _to.length; i++) {\n', '            assert((Token(_tokenAddr).transfer(_to[i], _value[i])) == true);\n', '        }\n', '        return true;\n', '    }\n', '}']
