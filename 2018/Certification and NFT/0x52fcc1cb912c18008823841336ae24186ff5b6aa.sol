['pragma solidity 0.4.18;\n', '\n', '// File: zeppelin-solidity/contracts/ownership/Ownable.sol\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '// File: contracts/Whitelist.sol\n', '\n', 'contract Whitelist is Ownable {\n', '    mapping(address => bool) public allowedAddresses;\n', '\n', '    event WhitelistUpdated(uint256 timestamp, string operation, address indexed member);\n', '\n', '    function addToWhitelist(address[] _addresses) public onlyOwner {\n', '        for (uint256 i = 0; i < _addresses.length; i++) {\n', '            allowedAddresses[_addresses[i]] = true;\n', '            WhitelistUpdated(now, "Added", _addresses[i]);\n', '        }\n', '    }\n', '\n', '    function removeFromWhitelist(address[] _addresses) public onlyOwner {\n', '        for (uint256 i = 0; i < _addresses.length; i++) {\n', '            allowedAddresses[_addresses[i]] = false;\n', '            WhitelistUpdated(now, "Removed", _addresses[i]);\n', '        }\n', '    }\n', '\n', '    function isWhitelisted(address _address) public view returns (bool) {\n', '        return allowedAddresses[_address];\n', '    }\n', '}']