['pragma solidity ^0.4.24;\n', '\n', '// File: node_modules/openzeppelin-solidity/contracts/access/Roles.sol\n', '\n', '/**\n', ' * @title Roles\n', ' * @dev Library for managing addresses assigned to a Role.\n', ' */\n', 'library Roles {\n', '  struct Role {\n', '    mapping (address => bool) bearer;\n', '  }\n', '\n', '  /**\n', '   * @dev give an account access to this role\n', '   */\n', '  function add(Role storage role, address account) internal {\n', '    require(account != address(0));\n', '    require(!has(role, account));\n', '\n', '    role.bearer[account] = true;\n', '  }\n', '\n', '  /**\n', "   * @dev remove an account's access to this role\n", '   */\n', '  function remove(Role storage role, address account) internal {\n', '    require(account != address(0));\n', '    require(has(role, account));\n', '\n', '    role.bearer[account] = false;\n', '  }\n', '\n', '  /**\n', '   * @dev check if an account has this role\n', '   * @return bool\n', '   */\n', '  function has(Role storage role, address account)\n', '    internal\n', '    view\n', '    returns (bool)\n', '  {\n', '    require(account != address(0));\n', '    return role.bearer[account];\n', '  }\n', '}\n', '\n', '// File: node_modules/openzeppelin-solidity/contracts/access/roles/PauserRole.sol\n', '\n', 'contract PauserRole {\n', '  using Roles for Roles.Role;\n', '\n', '  event PauserAdded(address indexed account);\n', '  event PauserRemoved(address indexed account);\n', '\n', '  Roles.Role private pausers;\n', '\n', '  constructor() internal {\n', '    _addPauser(msg.sender);\n', '  }\n', '\n', '  modifier onlyPauser() {\n', '    require(isPauser(msg.sender));\n', '    _;\n', '  }\n', '\n', '  function isPauser(address account) public view returns (bool) {\n', '    return pausers.has(account);\n', '  }\n', '\n', '  function addPauser(address account) public onlyPauser {\n', '    _addPauser(account);\n', '  }\n', '\n', '  function renouncePauser() public {\n', '    _removePauser(msg.sender);\n', '  }\n', '\n', '  function _addPauser(address account) internal {\n', '    pausers.add(account);\n', '    emit PauserAdded(account);\n', '  }\n', '\n', '  function _removePauser(address account) internal {\n', '    pausers.remove(account);\n', '    emit PauserRemoved(account);\n', '  }\n', '}\n', '\n', '// File: node_modules/openzeppelin-solidity/contracts/lifecycle/Pausable.sol\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is PauserRole {\n', '  event Paused(address account);\n', '  event Unpaused(address account);\n', '\n', '  bool private _paused;\n', '\n', '  constructor() internal {\n', '    _paused = false;\n', '  }\n', '\n', '  /**\n', '   * @return true if the contract is paused, false otherwise.\n', '   */\n', '  function paused() public view returns(bool) {\n', '    return _paused;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!_paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(_paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() public onlyPauser whenNotPaused {\n', '    _paused = true;\n', '    emit Paused(msg.sender);\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() public onlyPauser whenPaused {\n', '    _paused = false;\n', '    emit Unpaused(msg.sender);\n', '  }\n', '}\n', '\n', '// File: node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address private _owner;\n', '\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() internal {\n', '    _owner = msg.sender;\n', '    emit OwnershipTransferred(address(0), _owner);\n', '  }\n', '\n', '  /**\n', '   * @return the address of the owner.\n', '   */\n', '  function owner() public view returns(address) {\n', '    return _owner;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(isOwner());\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @return true if `msg.sender` is the owner of the contract.\n', '   */\n', '  function isOwner() public view returns(bool) {\n', '    return msg.sender == _owner;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to relinquish control of the contract.\n', '   * @notice Renouncing to ownership will leave the contract without an owner.\n', '   * It will not be possible to call the functions with the `onlyOwner`\n', '   * modifier anymore.\n', '   */\n', '  function renounceOwnership() public onlyOwner {\n', '    emit OwnershipTransferred(_owner, address(0));\n', '    _owner = address(0);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    _transferOwnership(newOwner);\n', '  }\n', '\n', '  /**\n', '   * @dev Transfers control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function _transferOwnership(address newOwner) internal {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(_owner, newOwner);\n', '    _owner = newOwner;\n', '  }\n', '}\n', '\n', '// File: contracts/IBounty.sol\n', '\n', 'interface IBounty {\n', '\n', '  function packageBounty(\n', '    address owner,\n', '    uint256 needHopsAmount,\n', '    address[] tokenAddress,\n', '    uint256[] tokenAmount)\n', '    external returns (bool);\n', '  \n', '  function openBounty(uint256 bountyId)\n', '    external returns (bool);\n', '  \n', '  function checkBounty(uint256 bountyId)\n', '    external view returns (address, uint256, address[], uint256[]);\n', '\n', '  /* Events */\n', '  event BountyEvt (\n', '    uint256 bountyId,\n', '    address owner,\n', '    uint256 needHopsAmount,\n', '    address[] tokenAddress,\n', '    uint256[] tokenAmount\n', '  );\n', '\n', '  event OpenBountyEvt (\n', '    uint256 bountyId,\n', '    address sender,\n', '    uint256 needHopsAmount,\n', '    address[] tokenAddress,\n', '    uint256[] tokenAmount\n', '  );\n', '}\n', '\n', '// File: contracts/Role/WhitelistAdminRole.sol\n', '\n', '/**\n', ' * @title WhitelistAdminRole\n', ' * @dev WhitelistAdmins are responsible for assigning and removing Whitelisted accounts.\n', ' */\n', 'contract WhitelistAdminRole {\n', '  using Roles for Roles.Role;\n', '\n', '  event WhitelistAdminAdded(address indexed account);\n', '  event WhitelistAdminRemoved(address indexed account);\n', '\n', '  Roles.Role private _whitelistAdmins;\n', '\n', '  constructor () internal {\n', '    _addWhitelistAdmin(msg.sender);\n', '  }\n', '\n', '  modifier onlyWhitelistAdmin() {\n', '    require(isWhitelistAdmin(msg.sender));\n', '    _;\n', '  }\n', '\n', '  function isWhitelistAdmin(address account) public view returns (bool) {\n', '    return _whitelistAdmins.has(account);\n', '  }\n', '\n', '  function addWhitelistAdmin(address account) public onlyWhitelistAdmin {\n', '    _addWhitelistAdmin(account);\n', '  }\n', '\n', '  function renounceWhitelistAdmin() public {\n', '    _removeWhitelistAdmin(msg.sender);\n', '  }\n', '\n', '  function _addWhitelistAdmin(address account) internal {\n', '    _whitelistAdmins.add(account);\n', '    emit WhitelistAdminAdded(account);\n', '  }\n', '\n', '  function _removeWhitelistAdmin(address account) internal {\n', '    _whitelistAdmins.remove(account);\n', '    emit WhitelistAdminRemoved(account);\n', '  }\n', '}\n', '\n', '// File: contracts/Role/WhitelistedRole.sol\n', '\n', '/**\n', ' * @title WhitelistedRole\n', ' * @dev Whitelisted accounts have been approved by a WhitelistAdmin to perform certain actions (e.g. participate in a\n', ' * crowdsale). This role is special in that the only accounts that can add it are WhitelistAdmins (who can also remove\n', ' * it), and not Whitelisteds themselves.\n', ' */\n', 'contract WhitelistedRole is WhitelistAdminRole {\n', '  using Roles for Roles.Role;\n', '\n', '  event WhitelistedAdded(address indexed account);\n', '  event WhitelistedRemoved(address indexed account);\n', '\n', '  Roles.Role private _whitelisteds;\n', '\n', '  modifier onlyWhitelisted() {\n', '    require(isWhitelisted(msg.sender));\n', '    _;\n', '  }\n', '\n', '  function isWhitelisted(address account) public view returns (bool) {\n', '    return _whitelisteds.has(account);\n', '  }\n', '\n', '  function addWhitelisted(address account) public onlyWhitelistAdmin {\n', '    _addWhitelisted(account);\n', '  }\n', '\n', '  function removeWhitelisted(address account) public onlyWhitelistAdmin {\n', '    _removeWhitelisted(account);\n', '  }\n', '\n', '  function renounceWhitelisted() public {\n', '    _removeWhitelisted(msg.sender);\n', '  }\n', '\n', '  function _addWhitelisted(address account) internal {\n', '    _whitelisteds.add(account);\n', '    emit WhitelistedAdded(account);\n', '  }\n', '\n', '  function _removeWhitelisted(address account) internal {\n', '    _whitelisteds.remove(account);\n', '    emit WhitelistedRemoved(account);\n', '  }\n', '}\n', '\n', '// File: contracts/SafeMath.sol\n', '\n', '/**\n', ' * @title SafeMath\n', ' */\n', 'library SafeMath {\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    // uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return a / b;\n', '  }\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) \n', '      internal \n', '      pure \n', '      returns (uint256 c) \n', '  {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    c = a * b;\n', '    require(c / a == b, "SafeMath mul failed");\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b)\n', '      internal\n', '      pure\n', '      returns (uint256) \n', '  {\n', '    require(b <= a, "SafeMath sub failed");\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b)\n', '      internal\n', '      pure\n', '      returns (uint256 c) \n', '  {\n', '    c = a + b;\n', '    require(c >= a, "SafeMath add failed");\n', '    return c;\n', '  }\n', '  \n', '  /**\n', '    * @dev gives square root of given x.\n', '    */\n', '  function sqrt(uint256 x)\n', '      internal\n', '      pure\n', '      returns (uint256 y) \n', '  {\n', '    uint256 z = ((add(x,1)) / 2);\n', '    y = x;\n', '    while (z < y) \n', '    {\n', '      y = z;\n', '      z = ((add((x / z),z)) / 2);\n', '    }\n', '  }\n', '  \n', '  /**\n', '    * @dev gives square. batchplies x by x\n', '    */\n', '  function sq(uint256 x)\n', '      internal\n', '      pure\n', '      returns (uint256)\n', '  {\n', '    return (mul(x,x));\n', '  }\n', '  \n', '  /**\n', '    * @dev x to the power of y \n', '    */\n', '  function pwr(uint256 x, uint256 y)\n', '      internal \n', '      pure \n', '      returns (uint256)\n', '  {\n', '    if (x==0)\n', '        return (0);\n', '    else if (y==0)\n', '        return (1);\n', '    else \n', '    {\n', '      uint256 z = x;\n', '      for (uint256 i=1; i < y; i++)\n', '        z = mul(z,x);\n', '      return (z);\n', '    }\n', '  }\n', '}\n', '\n', '// File: contracts/Bounty.sol\n', '\n', 'interface IERC20 {\n', '  function transfer(address to, uint256 value) external returns (bool);\n', '  function balanceOf(address who) external view returns (uint256);\n', '  function allowance(address tokenOwner, address spender) external view returns (uint256);\n', '  function burnFrom(address from, uint256 value) external;\n', '}\n', '\n', 'interface IERC721 {\n', '  function mintTo(address to) external returns (bool, uint256);\n', '  function ownerOf(uint256 tokenId) external view returns (address);\n', '  function burn(uint256 tokenId) external;\n', '  function isApprovedForAll(address owner, address operator) external view returns (bool);\n', '}\n', '\n', 'contract Bounty is WhitelistedRole, IBounty, Pausable {\n', '\n', '  using SafeMath for *;\n', '\n', '  address public erc20Address;\n', '  address public bountyNFTAddress;\n', '\n', '  struct Bounty {\n', '    uint256 needHopsAmount;\n', '    address[] tokenAddress;\n', '    uint256[] tokenAmount;\n', '  }\n', '\n', '  bytes32[] public planBaseIds;\n', '\n', '  mapping (uint256 => Bounty) bountyIdToBounty;\n', '\n', '  constructor (address _erc20Address, address _bountyNFTAddress) {\n', '    erc20Address = _erc20Address;\n', '    bountyNFTAddress = _bountyNFTAddress;\n', '  }\n', '\n', '  function packageBounty (\n', '    address owner,\n', '    uint256 needHopsAmount,\n', '    address[] tokenAddress,\n', '    uint256[] tokenAmount\n', '  ) whenNotPaused external returns (bool) {\n', '    require(isWhitelisted(msg.sender)||isWhitelistAdmin(msg.sender));\n', '    Bounty memory bounty = Bounty(needHopsAmount, tokenAddress, tokenAmount);\n', '    (bool success, uint256 bountyId) = IERC721(bountyNFTAddress).mintTo(owner);\n', '    require(success);\n', '    bountyIdToBounty[bountyId] = bounty;\n', '    emit BountyEvt(bountyId, owner, needHopsAmount, tokenAddress, tokenAmount);\n', '  }\n', '\n', '  function openBounty(uint256 bountyId)\n', '    whenNotPaused external returns (bool) {\n', '    Bounty storage bounty = bountyIdToBounty[bountyId];\n', '    require(IERC721(bountyNFTAddress).ownerOf(bountyId) == msg.sender);\n', '\n', '    require(IERC721(bountyNFTAddress).isApprovedForAll(msg.sender, address(this)));\n', '    require(IERC20(erc20Address).balanceOf(msg.sender) >= bounty.needHopsAmount);\n', '    require(IERC20(erc20Address).allowance(msg.sender, address(this)) >= bounty.needHopsAmount);\n', '    IERC20(erc20Address).burnFrom(msg.sender, bounty.needHopsAmount);\n', '\n', '    for (uint8 i = 0; i < bounty.tokenAddress.length; i++) {\n', '      require(IERC20(bounty.tokenAddress[i]).transfer(msg.sender, bounty.tokenAmount[i]));\n', '    }\n', '\n', '    IERC721(bountyNFTAddress).burn(bountyId);\n', '    delete bountyIdToBounty[bountyId];\n', '\n', '    emit OpenBountyEvt(bountyId, msg.sender, bounty.needHopsAmount, bounty.tokenAddress, bounty.tokenAmount);\n', '  }\n', '\n', '  function checkBounty(uint256 bountyId) external view returns (\n', '    address,\n', '    uint256,\n', '    address[],\n', '    uint256[]) {\n', '    Bounty storage bounty = bountyIdToBounty[bountyId];\n', '    address owner = IERC721(bountyNFTAddress).ownerOf(bountyId);\n', '    return (owner, bounty.needHopsAmount, bounty.tokenAddress, bounty.tokenAmount);\n', '  }\n', '}']