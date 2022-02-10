['// v7\n', '\n', '/**\n', ' * Vault.sol\n', ' * Vault contract is used for storing all team/founder tokens amounts from the crowdsale. It adds team members and their amounts in a list.\n', ' * Vault securely stores team members funds and freezes the particular X amount on set X amount of time.\n', ' * It also gives the ability to release the funds when the X set time limit is met.\n', ' */\n', '\n', 'pragma solidity ^0.4.23;\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title TokenContract\n', ' * @dev Token contract interface with transfer and balanceOf functions which need to be implemented\n', ' */\n', 'interface TokenContract {\n', '\n', '  /**\n', '  * @dev Transfer funds to recipient address\n', '  * @param _recipient Recipients address\n', '  * @param _amount Amount to transfer\n', '  */\n', '  function transfer(address _recipient, uint256 _amount) external returns (bool);\n', '\n', '  /**\n', '   * @dev Return balance of holders address\n', '   * @param _holder Holders address\n', '   */\n', '  function balanceOf(address _holder) external view returns (uint256);\n', '}\n', '\n', '/**\n', ' * @title Vault\n', ' * Vault contract is used for storing all team/founder tokens amounts from the crowdsale. It adds team members and their amounts in a list.\n', ' * Vault securely stores team members funds and freezes the particular X amount on set X amount of time.\n', ' * It also gives the ability to release the funds when the X set time limit is met.\n', ' */\n', 'contract Vault is Ownable {\n', '  TokenContract public tkn;\n', '\n', '  uint256 public releaseDate;\n', '\n', '  struct Member {\n', '    address memberAddress;\n', '    uint256 tokens;\n', '  }\n', '\n', '  Member[] public team;\n', '\n', '  /**\n', '   * @dev The Vault constructor sets the release date in epoch time\n', '   */\n', '  constructor() public {\n', '    releaseDate = 1561426200; // set release date in epoch\n', '  }\n', '\n', '  /**\n', '   * @dev Release tokens from vault - unlock them and destroy contract\n', '   */\n', '  function releaseTokens() onlyOwner public {\n', '    require(releaseDate > block.timestamp);\n', '    uint256 amount;\n', '    for (uint256 i = 0; i < team.length; i++) {\n', '      require(tkn.transfer(team[i].memberAddress, team[i].tokens));\n', '    }\n', '    amount = tkn.balanceOf(address(this));\n', '    require(tkn.transfer(owner, amount));\n', '    selfdestruct(owner);\n', '  }\n', '\n', '  /**\n', '   * @dev Add members to vault to lock funds\n', '   * @param _member Member to be added to the vault\n', '   * @param _tokens Amount of tokens to be locked\n', '   */\n', '  function addMembers(address[] _member, uint256[] _tokens) onlyOwner public {\n', '    require(_member.length > 0);\n', '    require(_member.length == _tokens.length);\n', '    Member memory member;\n', '    for (uint256 i = 0; i < _member.length; i++) {\n', '      member.memberAddress = _member[i];\n', '      member.tokens = _tokens[i];\n', '      team.push(member);\n', '    }\n', '  }\n', '}']