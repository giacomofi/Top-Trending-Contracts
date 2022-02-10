['pragma solidity ^0.4.19;\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20Basic {\n', '  uint256 public totalSupply;\n', '  function balanceOf(address who) public constant returns (uint256);\n', '  function transfer(address to, uint256 value) public returns (bool);\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '  function allowance(address owner, address spender) public constant returns (uint256);\n', '  function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '  function approve(address spender, uint256 value) public returns (bool);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract PaymentReceiver\n', '{\n', ' address private constant taxman = 0xB13D7Dab5505512924CB8E1bE970B849009d34Da;\n', ' address private constant store = 0x23859DBF88D714125C65d1B41a8808cADB199D9E;\n', ' address private constant pkt = 0x2604fa406be957e542beb89e6754fcde6815e83f;\n', '\n', '  modifier onlyTaxman { require(msg.sender == taxman); _; }\n', '\n', '  function withdrawTokens(uint256 value) external onlyTaxman\n', '  {\n', '    ERC20 token = ERC20(pkt);\n', '    token.transfer(store, value);\n', '  }\n', '}']