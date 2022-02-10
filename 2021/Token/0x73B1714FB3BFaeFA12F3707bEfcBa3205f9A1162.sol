['/**\n', ' *Submitted for verification at Etherscan.io on 2021-04-26\n', '*/\n', '\n', '// File: access/HasAdmin.sol\n', '\n', 'pragma solidity 0.5.17;\n', '\n', '\n', 'contract HasAdmin {\n', '  event AdminChanged(address indexed _oldAdmin, address indexed _newAdmin);\n', '  event AdminRemoved(address indexed _oldAdmin);\n', '\n', '  address public admin;\n', '\n', '  modifier onlyAdmin {\n', '    require(msg.sender == admin, "HasAdmin: not admin");\n', '    _;\n', '  }\n', '\n', '  constructor() internal {\n', '    admin = msg.sender;\n', '    emit AdminChanged(address(0), admin);\n', '  }\n', '\n', '  function changeAdmin(address _newAdmin) external onlyAdmin {\n', '    require(_newAdmin != address(0), "HasAdmin: new admin is the zero address");\n', '    emit AdminChanged(admin, _newAdmin);\n', '    admin = _newAdmin;\n', '  }\n', '\n', '  function removeAdmin() external onlyAdmin {\n', '    emit AdminRemoved(admin);\n', '    admin = address(0);\n', '  }\n', '}\n', '\n', '// File: token/erc20/IERC20.sol\n', '\n', 'pragma solidity 0.5.17;\n', '\n', '\n', 'interface IERC20 {\n', '  event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '  event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '\n', '  function totalSupply() external view returns (uint256 _supply);\n', '  function balanceOf(address _owner) external view returns (uint256 _balance);\n', '\n', '  function approve(address _spender, uint256 _value) external returns (bool _success);\n', '  function allowance(address _owner, address _spender) external view returns (uint256 _value);\n', '\n', '  function transfer(address _to, uint256 _value) external returns (bool _success);\n', '  function transferFrom(address _from, address _to, uint256 _value) external returns (bool _success);\n', '}\n', '\n', '// File: MainchainGateway.sol\n', '\n', 'pragma solidity 0.5.17;\n', '\n', '\n', 'contract MainchainGateway {\n', '  function depositERC20For(address _user, address _token, uint256 _amount) external returns (uint256);\n', '}\n', '\n', '// File: TokenSwap.sol\n', '\n', 'pragma solidity 0.5.17;\n', '\n', '\n', '\n', '\n', '\n', '/**\n', '  * Smart contract wallet to support swapping between old ERC-20 token to a new contract.\n', '  * It also supports swap and deposit into mainchainGateway in a single transaction.\n', '  * Pre-requisites: New token needs to be transferred to this contract.\n', '  * Dev should check that the decimals and supply of old token and new token are identical.\n', ' */\n', 'contract TokenSwap is HasAdmin {\n', '  IERC20 public oldToken;\n', '  IERC20 public newToken;\n', '  MainchainGateway public mainchainGateway;\n', '\n', '  constructor(\n', '    IERC20 _oldToken,\n', '    IERC20 _newToken\n', '  )\n', '    public\n', '  {\n', '    oldToken = _oldToken;\n', '    newToken = _newToken;\n', '  }\n', '\n', '  function setGateway(MainchainGateway _mainchainGateway) external onlyAdmin {\n', '    if (address(mainchainGateway) != address(0)) {\n', '      require(newToken.approve(address(mainchainGateway), 0));\n', '    }\n', '\n', '    mainchainGateway = _mainchainGateway;\n', '    require(newToken.approve(address(mainchainGateway), uint256(-1)));\n', '  }\n', '\n', '  function swapToken() external {\n', '    uint256 _balance = oldToken.balanceOf(msg.sender);\n', '    require(oldToken.transferFrom(msg.sender, address(this), _balance));\n', '    require(newToken.transfer(msg.sender, _balance));\n', '  }\n', '\n', '  function swapAndBridge(address _recipient, uint256 _amount) external {\n', '    require(_recipient != address(0), "TokenSwap: recipient is the zero address");\n', '    uint256 _balance = oldToken.balanceOf(msg.sender);\n', '    require(oldToken.transferFrom(msg.sender, address(this), _balance));\n', '\n', '    require(_amount <= _balance);\n', '    require(newToken.transfer(msg.sender, _balance - _amount));\n', '    mainchainGateway.depositERC20For(_recipient, address(newToken), _amount);\n', '  }\n', '\n', '  function swapAndBridgeAll(address _recipient) external {\n', '    require(_recipient != address(0), "TokenSwap: recipient is the zero address");\n', '    uint256 _balance = oldToken.balanceOf(msg.sender);\n', '    require(oldToken.transferFrom(msg.sender, address(this), _balance));\n', '    mainchainGateway.depositERC20For(_recipient, address(newToken), _balance);\n', '  }\n', '\n', '  // Used when some old token lost forever\n', '  function withdrawToken() external onlyAdmin {\n', '    newToken.transfer(msg.sender, newToken.balanceOf(address(this)));\n', '  }\n', '}']