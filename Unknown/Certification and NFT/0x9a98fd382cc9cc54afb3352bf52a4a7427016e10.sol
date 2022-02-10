['pragma solidity ^0.4.11;\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner {\n', '    if (newOwner != address(0)) {\n', '      owner = newOwner;\n', '    }\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract KyberContirbutorWhitelist is Ownable {\n', '    mapping(address=>uint) addressCap;\n', '    \n', '    function KyberContirbutorWhitelist() {}\n', '    \n', '    event ListAddress( address _user, uint _cap, uint _time );\n', '    \n', '    // Owner can delist by setting cap = 0.\n', '    // Onwer can also change it at any time\n', '    function listAddress( address _user, uint _cap ) onlyOwner {\n', '        addressCap[_user] = _cap;\n', '        ListAddress( _user, _cap, now );\n', '    }\n', '    \n', '    function getCap( address _user ) constant returns(uint) {\n', '        return addressCap[_user];\n', '    }\n', '}\n', '\n', 'contract KyberContirbutorWhitelistOptimized is KyberContirbutorWhitelist {\n', '    uint public slackUsersCap = 7;\n', '    \n', '    function KyberContirbutorWhitelistOptimized() {}\n', '    \n', '    function listAddresses( address[] _users, uint[] _cap ) onlyOwner {\n', '        require(_users.length == _cap.length );\n', '        for( uint i = 0 ; i < _users.length ; i++ ) {\n', '            listAddress( _users[i], _cap[i] );   \n', '        }\n', '    }\n', '    \n', '    function setSlackUsersCap( uint _cap ) onlyOwner {\n', '        slackUsersCap = _cap;        \n', '    }\n', '    \n', '    function getCap( address _user ) constant returns(uint) {\n', '        uint cap = super.getCap(_user);\n', '        \n', '        if( cap == 1 ) return slackUsersCap;\n', '        else return cap;\n', '    }\n', '}']
['pragma solidity ^0.4.11;\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner {\n', '    if (newOwner != address(0)) {\n', '      owner = newOwner;\n', '    }\n', '  }\n', '\n', '}\n', '\n', '\n', 'contract KyberContirbutorWhitelist is Ownable {\n', '    mapping(address=>uint) addressCap;\n', '    \n', '    function KyberContirbutorWhitelist() {}\n', '    \n', '    event ListAddress( address _user, uint _cap, uint _time );\n', '    \n', '    // Owner can delist by setting cap = 0.\n', '    // Onwer can also change it at any time\n', '    function listAddress( address _user, uint _cap ) onlyOwner {\n', '        addressCap[_user] = _cap;\n', '        ListAddress( _user, _cap, now );\n', '    }\n', '    \n', '    function getCap( address _user ) constant returns(uint) {\n', '        return addressCap[_user];\n', '    }\n', '}\n', '\n', 'contract KyberContirbutorWhitelistOptimized is KyberContirbutorWhitelist {\n', '    uint public slackUsersCap = 7;\n', '    \n', '    function KyberContirbutorWhitelistOptimized() {}\n', '    \n', '    function listAddresses( address[] _users, uint[] _cap ) onlyOwner {\n', '        require(_users.length == _cap.length );\n', '        for( uint i = 0 ; i < _users.length ; i++ ) {\n', '            listAddress( _users[i], _cap[i] );   \n', '        }\n', '    }\n', '    \n', '    function setSlackUsersCap( uint _cap ) onlyOwner {\n', '        slackUsersCap = _cap;        \n', '    }\n', '    \n', '    function getCap( address _user ) constant returns(uint) {\n', '        uint cap = super.getCap(_user);\n', '        \n', '        if( cap == 1 ) return slackUsersCap;\n', '        else return cap;\n', '    }\n', '}']
