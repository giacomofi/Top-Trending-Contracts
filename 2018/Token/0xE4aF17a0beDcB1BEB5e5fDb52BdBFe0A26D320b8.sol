['pragma solidity ^0.4.23;\n', '\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function balanceOf(address who) public view returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender)\n', '    public view returns (uint256);\n', '\n', '  function transferFrom(address from, address to, uint256 value)\n', '    public returns (bool);\n', '\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(\n', '    address indexed owner,\n', '    address indexed spender,\n', '    uint256 value\n', '  );\n', '}\n', '\n', '\n', '/**\n', ' * @title SafeERC20\n', ' * @dev Wrappers around ERC20 operations that throw on failure.\n', ' * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,\n', ' * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.\n', ' */\n', 'library SafeERC20 {\n', '  function safeTransfer(ERC20Basic token, address to, uint256 value) internal {\n', '    require(token.transfer(to, value));\n', '  }\n', '\n', '  function safeTransferFrom(\n', '    ERC20 token,\n', '    address from,\n', '    address to,\n', '    uint256 value\n', '  )\n', '    internal\n', '  {\n', '    require(token.transferFrom(from, to, value));\n', '  }\n', '\n', '  function safeApprove(ERC20 token, address spender, uint256 value) internal {\n', '    require(token.approve(spender, value));\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title TokenTimelock\n', ' * @dev TokenTimelock is a token holder contract that will allow a\n', ' * beneficiary to extract the tokens after a given release time\n', ' */\n', 'contract TokenTimelock {\n', '  using SafeERC20 for ERC20Basic;\n', '\n', '  // ERC20 basic token contract being held\n', '  ERC20Basic public token;\n', '\n', '  // beneficiary of tokens after they are released\n', '  address public beneficiary;\n', '\n', '  // timestamp when token release is enabled\n', '  uint256 public releaseTime;\n', '\n', '  constructor(\n', '    ERC20Basic _token,\n', '    address _beneficiary,\n', '    uint256 _releaseTime\n', '  )\n', '    public\n', '  {\n', '    // solium-disable-next-line security/no-block-members\n', '    require(_releaseTime > block.timestamp);\n', '    token = _token;\n', '    beneficiary = _beneficiary;\n', '    releaseTime = _releaseTime;\n', '  }\n', '\n', '  /**\n', '   * @notice Transfers tokens held by timelock to beneficiary.\n', '   */\n', '  function release() public {\n', '    // solium-disable-next-line security/no-block-members\n', '    require(block.timestamp >= releaseTime);\n', '\n', '    uint256 amount = token.balanceOf(this);\n', '    require(amount > 0);\n', '\n', '    token.safeTransfer(beneficiary, amount);\n', '  }\n', '}']