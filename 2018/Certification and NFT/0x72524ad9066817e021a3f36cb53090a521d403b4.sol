['pragma solidity ^0.4.24;\n', '\n', '/**\n', '* @title Ownable\n', '* @dev The Ownable contract has an owner address, and provides basic authorization control\n', '* functions, this simplifies the implementation of "user permissions".\n', '*/\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '    /**\n', '    * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '    * account.\n', '    */\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '    * @dev Throws if called by any account other than the owner.\n', '    */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '    * @param newOwner The address to transfer ownership to.\n', '    */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '\n', '}\n', '\n', 'contract SnowflakeResolver is Ownable {\n', '    string public snowflakeName;\n', '    string public snowflakeDescription;\n', '    address public snowflakeAddress;\n', '\n', '    bool public callOnSignUp;\n', '    bool public callOnRemoval;\n', '\n', '    function setSnowflakeAddress(address _address) public onlyOwner {\n', '        snowflakeAddress = _address;\n', '    }\n', '\n', '    modifier senderIsSnowflake() {\n', '        require(msg.sender == snowflakeAddress, "Did not originate from Snowflake.");\n', '        _;\n', '    }\n', '\n', '    // onSignUp is called every time a user sets your contract as a resolver if callOnSignUp is true\n', '    // this function **must** use the senderIsSnowflake modifier\n', '    // returning false will disallow users from setting your contract as a resolver\n', '    // function onSignUp(string hydroId, uint allowance) public returns (bool);\n', '\n', '    // onRemoval is called every time a user sets your contract as a resolver if callOnRemoval is true\n', '    // this function **must** use the senderIsSnowflake modifier\n', '    // returning false soft prevents users from removing your contract as a resolver\n', '    // however, they can force remove your resolver, bypassing this function\n', '    // function onRemoval(string hydroId, uint allowance) public returns (bool);\n', '}\n', '\n', '\n', 'interface Snowflake {\n', '    function whitelistResolver(address resolver) external;\n', '    function withdrawSnowflakeBalanceFrom(string hydroIdFrom, address to, uint amount) external;\n', '    function getHydroId(address _address) external returns (string hydroId);\n', '}\n', '\n', '\n', 'contract Status is SnowflakeResolver {\n', '    mapping (string => string) internal statuses;\n', '\n', '    uint signUpFee = 1000000000000000000;\n', '    string firstStatus = "My first status &#128526;";\n', '\n', '    constructor (address snowflakeAddress) public {\n', '        snowflakeName = "Status";\n', '        snowflakeDescription = "Set your status.";\n', '        setSnowflakeAddress(snowflakeAddress);\n', '\n', '        callOnSignUp = true;\n', '\n', '        Snowflake snowflake = Snowflake(snowflakeAddress);\n', '        snowflake.whitelistResolver(address(this));\n', '    }\n', '\n', '    // implement signup function\n', '    function onSignUp(string hydroId, uint allowance) public senderIsSnowflake() returns (bool) {\n', '        require(allowance >= signUpFee, "Must set an allowance of at least 1 HYDRO.");\n', '        Snowflake snowflake = Snowflake(snowflakeAddress);\n', '        snowflake.withdrawSnowflakeBalanceFrom(hydroId, owner, signUpFee);\n', '        statuses[hydroId] = firstStatus;\n', '        emit StatusUpdated(hydroId, firstStatus);\n', '        return true;\n', '    }\n', '\n', '    function getStatus(string hydroId) public view returns (string) {\n', '        return statuses[hydroId];\n', '    }\n', '\n', '    // example function that calls withdraw on a linked hydroID\n', '    function setStatus(string status) public {\n', '        Snowflake snowflake = Snowflake(snowflakeAddress);\n', '        string memory hydroId = snowflake.getHydroId(msg.sender);\n', '        statuses[hydroId] = status;\n', '        emit StatusUpdated(hydroId, status);\n', '    }\n', '\n', '    event StatusUpdated(string hydroId, string status);\n', '}']