['pragma solidity ^0.4.13;\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner {\n', '    if (newOwner != address(0)) {\n', '      owner = newOwner;\n', '    }\n', '  }\n', '\n', '}\n', '\n', 'contract KyberContributorWhitelist is Ownable {\n', '    // 7 wei is a dummy cap. Will be set by owner to a real cap after registration ends.\n', '    uint public slackUsersCap = 7;\n', '    mapping(address=>uint) public addressCap;\n', '\n', '    function KyberContributorWhitelist() {}\n', '\n', '    event ListAddress( address _user, uint _cap, uint _time );\n', '\n', '    // Owner can delist by setting cap = 0.\n', '    // Onwer can also change it at any time\n', '    function listAddress( address _user, uint _cap ) onlyOwner {\n', '        addressCap[_user] = _cap;\n', '        ListAddress( _user, _cap, now );\n', '    }\n', '\n', '    // an optimasition in case of network congestion\n', '    function listAddresses( address[] _users, uint[] _cap ) onlyOwner {\n', '        require(_users.length == _cap.length );\n', '        for( uint i = 0 ; i < _users.length ; i++ ) {\n', '            listAddress( _users[i], _cap[i] );\n', '        }\n', '    }\n', '\n', '    function setSlackUsersCap( uint _cap ) onlyOwner {\n', '        slackUsersCap = _cap;\n', '    }\n', '\n', '    function getCap( address _user ) constant returns(uint) {\n', '        uint cap = addressCap[_user];\n', '\n', '        if( cap == 1 ) return slackUsersCap;\n', '        else return cap;\n', '    }\n', '\n', '    function destroy() onlyOwner {\n', '        selfdestruct(owner);\n', '    }\n', '}']
['pragma solidity ^0.4.13;\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner {\n', '    if (newOwner != address(0)) {\n', '      owner = newOwner;\n', '    }\n', '  }\n', '\n', '}\n', '\n', 'contract KyberContributorWhitelist is Ownable {\n', '    // 7 wei is a dummy cap. Will be set by owner to a real cap after registration ends.\n', '    uint public slackUsersCap = 7;\n', '    mapping(address=>uint) public addressCap;\n', '\n', '    function KyberContributorWhitelist() {}\n', '\n', '    event ListAddress( address _user, uint _cap, uint _time );\n', '\n', '    // Owner can delist by setting cap = 0.\n', '    // Onwer can also change it at any time\n', '    function listAddress( address _user, uint _cap ) onlyOwner {\n', '        addressCap[_user] = _cap;\n', '        ListAddress( _user, _cap, now );\n', '    }\n', '\n', '    // an optimasition in case of network congestion\n', '    function listAddresses( address[] _users, uint[] _cap ) onlyOwner {\n', '        require(_users.length == _cap.length );\n', '        for( uint i = 0 ; i < _users.length ; i++ ) {\n', '            listAddress( _users[i], _cap[i] );\n', '        }\n', '    }\n', '\n', '    function setSlackUsersCap( uint _cap ) onlyOwner {\n', '        slackUsersCap = _cap;\n', '    }\n', '\n', '    function getCap( address _user ) constant returns(uint) {\n', '        uint cap = addressCap[_user];\n', '\n', '        if( cap == 1 ) return slackUsersCap;\n', '        else return cap;\n', '    }\n', '\n', '    function destroy() onlyOwner {\n', '        selfdestruct(owner);\n', '    }\n', '}']
