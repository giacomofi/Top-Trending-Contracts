['pragma solidity ^0.4.23;\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '\n', '    event OwnershipRenounced(address indexed previousOwner);\n', '    event OwnershipTransferred(\n', '        address indexed previousOwner,\n', '        address indexed newOwner\n', '    );\n', '\n', '\n', '    /**\n', '    * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '    * account.\n', '    */\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '    * @dev Throws if called by any account other than the owner.\n', '    */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev Allows the current owner to relinquish control of the contract.\n', '    * @notice Renouncing to ownership will leave the contract without an owner.\n', '    * It will not be possible to call the functions with the `onlyOwner`\n', '    * modifier anymore.\n', '    */\n', '    function renounceOwnership() public onlyOwner {\n', '        emit OwnershipRenounced(owner);\n', '        owner = address(0);\n', '    }\n', '\n', '    /**\n', '    * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '    * @param _newOwner The address to transfer ownership to.\n', '    */\n', '    function transferOwnership(address _newOwner) public onlyOwner {\n', '        _transferOwnership(_newOwner);\n', '    }\n', '\n', '    /**\n', '    * @dev Transfers control of the contract to a newOwner.\n', '    * @param _newOwner The address to transfer ownership to.\n', '    */\n', '    function _transferOwnership(address _newOwner) internal {\n', '        require(_newOwner != address(0));\n', '        emit OwnershipTransferred(owner, _newOwner);\n', '        owner = _newOwner;\n', '    }\n', '}\n', '\n', '\n', '/** @title Restricted\n', ' *  Exposes onlyMonetha modifier\n', ' */\n', 'contract Restricted is Ownable {\n', '\n', '    event MonethaAddressSet(\n', '        address _address,\n', '        bool _isMonethaAddress\n', '    );\n', '\n', '    mapping (address => bool) public isMonethaAddress;\n', '\n', '    /**\n', '     *  Restrict methods in such way, that they can be invoked only by monethaAddress account.\n', '     */\n', '    modifier onlyMonetha() {\n', '        require(isMonethaAddress[msg.sender]);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     *  Allows owner to set new monetha address\n', '     */\n', '    function setMonethaAddress(address _address, bool _isMonethaAddress) onlyOwner public {\n', '        isMonethaAddress[_address] = _isMonethaAddress;\n', '\n', '        MonethaAddressSet(_address, _isMonethaAddress);\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' *  @title MonethaSupportedTokens\n', ' *\n', ' *  MonethaSupportedTokens stores all erc20 token supported by Monetha\n', ' */\n', 'contract MonethaSupportedTokens is Restricted {\n', '    \n', '    string constant VERSION = "0.1";\n', '    \n', '    struct Token {\n', '        bytes32 token_acronym;\n', '        address token_address;\n', '    }\n', '    \n', '    mapping (uint => Token) public tokens;\n', '\n', '    uint public tokenId;\n', '    \n', '    address[] private allAddresses;\n', '    bytes32[] private allAccronym;\n', '    \n', '    function addToken(bytes32 _tokenAcronym, address _tokenAddress)\n', '        external onlyMonetha\n', '    {\n', '        require(_tokenAddress != address(0));\n', '\n', '        tokens[++tokenId] = Token({\n', '            token_acronym: bytes32(_tokenAcronym),\n', '            token_address: _tokenAddress\n', '        });\n', '        allAddresses.push(_tokenAddress);\n', '        allAccronym.push(bytes32(_tokenAcronym));\n', '    }\n', '    \n', '    function deleteToken(uint _tokenId)\n', '        external onlyMonetha\n', '    {\n', '        \n', '        tokens[_tokenId].token_address = tokens[tokenId].token_address;\n', '        tokens[_tokenId].token_acronym = tokens[tokenId].token_acronym;\n', '\n', '        uint len = allAddresses.length;\n', '        allAddresses[_tokenId-1] = allAddresses[len-1];\n', '        allAccronym[_tokenId-1] = allAccronym[len-1];\n', '        allAddresses.length--;\n', '        allAccronym.length--;\n', '        delete tokens[tokenId];\n', '        tokenId--;\n', '    }\n', '    \n', '    function getAll() external view returns (address[], bytes32[])\n', '    {\n', '        return (allAddresses, allAccronym);\n', '    }\n', '    \n', '}']