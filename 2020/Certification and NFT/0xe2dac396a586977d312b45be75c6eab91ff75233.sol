['pragma solidity ^0.5.17;\n', '\n', 'library SafeMath {\n', '  function add(uint a, uint b) internal pure returns (uint c) {\n', '    c = a + b;\n', '    require(c >= a);\n', '  }\n', '  function sub(uint a, uint b) internal pure returns (uint c) {\n', '    require(b <= a);\n', '    c = a - b;\n', '  }\n', '  function mul(uint a, uint b) internal pure returns (uint c) {\n', '    c = a * b;\n', '    require(a == 0 || c / a == b);\n', '  }\n', '  function div(uint a, uint b) internal pure returns (uint c) {\n', '    require(b > 0);\n', '    c = a / b;\n', '  }\n', '}\n', '\n', 'contract ERC20Interface {\n', '    \n', '  function totalSupply() public view returns (uint);\n', '  function balanceOf(address tokenOwner) public view returns (uint balance);\n', '  function allowance(address tokenOwner, address spender) public view returns (uint remaining);\n', '  function transfer(address to, uint tokens) public returns (bool success);\n', '  function approve(address spender, uint tokens) public returns (bool success);\n', '  function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '\n', '  \n', '}\n', '\n', '\n', 'contract ApproveAndCallFallBack {\n', '  function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;\n', '}\n', '\n', 'contract Owned {\n', '  address public Admininstrator;\n', '\n', '\n', '  constructor() public {\n', '    Admininstrator = msg.sender;\n', '    \n', '  }\n', '\n', '  modifier onlyAdmin {\n', '    require(msg.sender == Admininstrator, "Only authorized personnels");\n', '    _;\n', '  }\n', '\n', '}\n', '\n', 'contract salescontract is Owned{\n', '    \n', '    \n', '  using SafeMath for uint;\n', ' \n', '  address public token;\n', '  \n', '  uint public minBuy = 0.5 ether;\n', '  uint public maxBuy = 5 ether;\n', '  address payable public saleswallet;\n', '  \n', '  bool public startSales = false;\n', '  uint public buyvalue;\n', ' \n', '  \n', '  uint public _qtty;\n', '  uint decimal = 10**18;\n', '\n', ' \n', '  mapping(address => uint) public buyamount;\n', '  uint256 public price = 0.066666555 ether;\n', '  \n', '  \n', ' \n', '  constructor() public { Admininstrator = msg.sender; }\n', '   \n', ' //========================================CONFIGURATIONS======================================\n', ' \n', ' \n', ' function WalletSetup(address payable _salewallet) public onlyAdmin{saleswallet = _salewallet;}\n', ' function setToken(address _tokenaddress) public onlyAdmin{token = _tokenaddress;}\n', ' \n', ' function AllowSales(bool _status) public onlyAdmin{\n', '     require(saleswallet != address(0));\n', '     startSales = _status;}\n', '\t\n', '\t\n', ' function () external payable {\n', '    \n', '    require(startSales == true, "Sales has not been initialized yet");\n', '    require(msg.value >= minBuy && msg.value <= maxBuy, "Invalid buy amount, confirm the maximum and minimum buy amounts");\n', '    require(token != 0x0000000000000000000000000000000000000000, "Selling token not yet configured");\n', '    require((buyamount[msg.sender] + msg.value) <= maxBuy, "Ensure your total buy is not above maximum allowed per wallet");\n', '    \n', '    buyvalue = msg.value;\n', '    _qtty = buyvalue.div(price);\n', '    require(ERC20Interface(token).balanceOf(address(this)) >= _qtty*decimal, "Insufficient tokens in the contract");\n', '    \n', '    saleswallet.transfer(msg.value);\n', '    buyamount[msg.sender] += msg.value;\n', '    require(ERC20Interface(token).transfer(msg.sender, _qtty*decimal), "Transaction failed");\n', '      \n', '       \n', '   \n', '    \n', '   \n', '  }\n', '  \n', '  \t\n', ' function buy() external payable {\n', '    \n', '    \n', '    require(startSales == true, "Sales has not been initialized yet");\n', '    require(msg.value >= minBuy && msg.value <= maxBuy, "Invalid buy amount, confirm the maximum and minimum buy amounts");\n', '    require(token != 0x0000000000000000000000000000000000000000, "Selling token not yet configured");\n', '    require((buyamount[msg.sender] + msg.value) <= maxBuy, "Ensure you total buy is not above maximum allowed per wallet");\n', '    \n', '    buyvalue = msg.value;\n', '    _qtty = buyvalue.div(price);\n', '    require(ERC20Interface(token).balanceOf(address(this)) >= _qtty*decimal, "Insufficient tokens in the contract");\n', '    \n', '    saleswallet.transfer(msg.value);\n', '    buyamount[msg.sender] += msg.value;\n', '    require(ERC20Interface(token).transfer(msg.sender, _qtty*decimal), "Transaction failed");\n', '      \n', '        \n', '    \n', '   \n', '  }\n', '  \n', '\n', '\n', '  function withdrawBal() public onlyAdmin returns(bool){\n', '      \n', '      require(saleswallet != address(0));\n', '      uint bal = ERC20Interface(token).balanceOf(address(this));\n', '      require(ERC20Interface(token).transfer(saleswallet, bal), "Transaction failed");\n', '      \n', '  }\n', ' \n', ' \n', '}']