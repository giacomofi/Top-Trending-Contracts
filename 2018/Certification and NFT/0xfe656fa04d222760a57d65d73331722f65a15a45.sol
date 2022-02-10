['pragma solidity 0.4.25;\n', '\n', 'contract Ownable {\n', '  address private _owner;\n', '\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() internal {\n', '    _owner = msg.sender;\n', '    emit OwnershipTransferred(address(0), _owner);\n', '  }\n', '\n', '  /**\n', '   * @return the address of the owner.\n', '   */\n', '  function owner() public view returns(address) {\n', '    return _owner;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(isOwner());\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @return true if `msg.sender` is the owner of the contract.\n', '   */\n', '  function isOwner() public view returns(bool) {\n', '    return msg.sender == _owner;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to relinquish control of the contract.\n', '   * @notice Renouncing to ownership will leave the contract without an owner.\n', '   * It will not be possible to call the functions with the `onlyOwner`\n', '   * modifier anymore.\n', '   */\n', '  function renounceOwnership() public onlyOwner {\n', '    emit OwnershipTransferred(_owner, address(0));\n', '    _owner = address(0);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    _transferOwnership(newOwner);\n', '  }\n', '\n', '  /**\n', '   * @dev Transfers control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function _transferOwnership(address newOwner) internal {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(_owner, newOwner);\n', '    _owner = newOwner;\n', '  }\n', '}\n', '\n', 'contract ERC20 {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  function allowance(address owner, address spender)\n', '    public view returns (uint256);\n', '\n', '  function transferFrom(address from, address to, uint256 value)\n', '    public returns (bool);\n', '\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '  event Approval(\n', '    address indexed owner,\n', '    address indexed spender,\n', '    uint256 value\n', '  );\n', '}\n', '\n', '\n', 'library SafeERC20 {\n', '  function safeTransfer(ERC20 token, address to, uint256 value) internal {\n', '    require(token.transfer(to, value));\n', '  }\n', '\n', '  function safeTransferFrom(\n', '    ERC20 token,\n', '    address from,\n', '    address to,\n', '    uint256 value\n', '  )\n', '    internal\n', '  {\n', '    require(token.transferFrom(from, to, value));\n', '  }\n', '\n', '  function safeApprove(ERC20 token, address spender, uint256 value) internal {\n', '    require(token.approve(spender, value));\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title TokenTimelock\n', ' * @dev TokenTimelock is a token holder contract that will allow a\n', ' * beneficiary to extract the tokens after a given release time\n', ' */\n', 'contract CGCXMassLock is Ownable {\n', '  using SafeERC20 for ERC20;\n', '\n', '  // ERC20 basic token contract being held\n', '  ERC20 public token;\n', '\n', '  // beneficiery -> amounts\n', '  mapping (address => uint256) public lockups;\n', '\n', '  // timestamp when token release is enabled\n', '  uint256 public releaseTime;\n', '\n', '  constructor(\n', '    address _token\n', '  )\n', '    public\n', '  {\n', '    // solium-disable-next-line security/no-block-members\n', '    token = ERC20(_token);\n', '    releaseTime = 1546128000; // 30 Dec 2018\n', '  }\n', '\n', '  function release() public  {\n', '    releaseFrom(msg.sender);\n', '  }\n', '\n', '  function releaseFrom(address _beneficiary) public {\n', '    require(block.timestamp >= releaseTime);\n', '    uint256 amount = lockups[_beneficiary];\n', '    require(amount > 0);\n', '    token.safeTransfer(_beneficiary, amount);\n', '    lockups[_beneficiary] = 0;\n', '  }\n', '\n', '  function releaseFromMultiple(address[] _addresses) public {\n', '    for (uint256 i = 0; i < _addresses.length; i++) {\n', '      releaseFrom(_addresses[i]);\n', '    }\n', '  } \n', '\n', '  function submit(address[] _addresses, uint256[] _amounts) public onlyOwner {\n', '    for (uint256 i = 0; i < _addresses.length; i++) {\n', '      lockups[_addresses[i]] = _amounts[i];\n', '    }\n', '  }\n', '\n', '}']