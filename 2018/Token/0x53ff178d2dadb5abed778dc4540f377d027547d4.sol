['pragma solidity ^0.4.13;\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipRenounced(address indexed previousOwner);\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to relinquish control of the contract.\n', '   * @notice Renouncing to ownership will leave the contract without an owner.\n', '   * It will not be possible to call the functions with the `onlyOwner`\n', '   * modifier anymore.\n', '   */\n', '  function renounceOwnership() public onlyOwner {\n', '    emit OwnershipRenounced(owner);\n', '    owner = address(0);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address _newOwner) public onlyOwner {\n', '    _transferOwnership(_newOwner);\n', '  }\n', '\n', '  /**\n', '   * @dev Transfers control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function _transferOwnership(address _newOwner) internal {\n', '    require(_newOwner != address(0));\n', '    emit OwnershipTransferred(owner, _newOwner);\n', '    owner = _newOwner;\n', '  }\n', '}\n', '\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address _who) public view returns (uint256);\n', '  function transfer(address _to, uint256 _value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address _owner, address _spender)\n', '    public view returns (uint256);\n', '\n', '  function transferFrom(address _from, address _to, uint256 _value)\n', '    public returns (bool);\n', '\n', '  function approve(address _spender, uint256 _value) public returns (bool);\n', '  event Approval(\n', '    address indexed owner,\n', '    address indexed spender,\n', '    uint256 value\n', '  );\n', '}\n', '\n', 'library SafeERC20 {\n', '  function safeTransfer(\n', '    ERC20Basic _token,\n', '    address _to,\n', '    uint256 _value\n', '  )\n', '    internal\n', '  {\n', '    require(_token.transfer(_to, _value));\n', '  }\n', '\n', '  function safeTransferFrom(\n', '    ERC20 _token,\n', '    address _from,\n', '    address _to,\n', '    uint256 _value\n', '  )\n', '    internal\n', '  {\n', '    require(_token.transferFrom(_from, _to, _value));\n', '  }\n', '\n', '  function safeApprove(\n', '    ERC20 _token,\n', '    address _spender,\n', '    uint256 _value\n', '  )\n', '    internal\n', '  {\n', '    require(_token.approve(_spender, _value));\n', '  }\n', '}\n', '\n', 'contract MenloTokenTimelock is Ownable {\n', '  using SafeERC20 for ERC20Basic;\n', '\n', '  // ERC20 basic token contract being held\n', '  ERC20Basic public token;\n', '\n', '  mapping (address => uint256) public balance;\n', '\n', '  // timestamp when token release is enabled\n', '  uint256 public releaseTime;\n', '\n', '  constructor(ERC20Basic _token, uint256 _releaseTime) public {\n', '    require(_releaseTime > now, "Release time should be in the future");\n', '    token = _token;\n', '    releaseTime = _releaseTime;\n', '  }\n', '\n', '  function deposit(address _beneficiary, uint256 _amount) public onlyOwner {\n', '    balance[_beneficiary] += _amount;\n', '  }\n', '\n', '  /**\n', '   * @notice Transfers tokens held by timelock to beneficiary.\n', '   */\n', '  function release() public {\n', '    require(getBlockTimestamp() >= releaseTime, "Release time should be now or in the past");\n', '\n', '    uint256 _amount = token.balanceOf(this);\n', '    require(_amount > 0, "Contract balance should be greater than zero");\n', '\n', '    require(balance[msg.sender] > 0, "Sender balance should be greater than zero");\n', '    require(_amount >= balance[msg.sender], "Expected contract balance to be greater than or equal to sender balance");\n', '    token.transfer(msg.sender, balance[msg.sender]);\n', '    balance[msg.sender] = 0;\n', '  }\n', '\n', '  function getBlockTimestamp() internal view returns (uint256) {\n', '    return block.timestamp;\n', '  }\n', '}']