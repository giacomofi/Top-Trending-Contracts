['pragma solidity ^0.5.17;\n', '\n', 'library SafeMath {\n', '  function add(uint a, uint b) internal pure returns (uint c) {\n', '    c = a + b;\n', '    require(c >= a);\n', '  }\n', '  function sub(uint a, uint b) internal pure returns (uint c) {\n', '    require(b <= a);\n', '    c = a - b;\n', '  }\n', '  function mul(uint a, uint b) internal pure returns (uint c) {\n', '    c = a * b;\n', '    require(a == 0 || c / a == b);\n', '  }\n', '  function div(uint a, uint b) internal pure returns (uint c) {\n', '    require(b > 0);\n', '    c = a / b;\n', '  }\n', '}\n', '\n', 'contract ERC20Interface {\n', '    \n', '  function totalSupply() public view returns (uint);\n', '  function balanceOf(address tokenOwner) public view returns (uint balance);\n', '  function allowance(address tokenOwner, address spender) public view returns (uint remaining);\n', '  function transfer(address to, uint tokens) public returns (bool success);\n', '  function approve(address spender, uint tokens) public returns (bool success);\n', '  function transferFrom(address from, address to, uint tokens) public returns (bool success);\n', '\n', '  \n', '}\n', '\n', 'interface WHITELISTCONTRACT {\n', '   \n', '   function isWhitelisted(address _address) external view returns (bool);\n', '   \n', ' } \n', '\n', 'contract ApproveAndCallFallBack {\n', '  function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;\n', '}\n', '\n', 'contract Owned {\n', '  address public Admininstrator;\n', '  address public newOwner;\n', '\n', '  event OwnershipTransferred(address indexed _from, address indexed _to);\n', '\n', '  constructor() public {\n', '    Admininstrator = msg.sender;\n', '    \n', '  }\n', '\n', '  modifier onlyAdmin {\n', '    require(msg.sender == Admininstrator, "Only authorized personnels");\n', '    _;\n', '  }\n', '\n', '}\n', '\n', 'contract PUBLICSALE is Owned{\n', '    \n', '    \n', '  using SafeMath for uint;\n', ' \n', '  address public sellingtoken;\n', '  address public conditiontoken;\n', '  \n', '  uint public minBuy = 1 ether;\n', '  uint public maxBuy = 2 ether;\n', '  address payable saleswallet;\n', '  \n', '  uint public _conditionAmount = 20000000000000000000;\n', '  bool public startSales = false;\n', '  uint public buyvalue;\n', '  uint public price = 0.00018181818 ether;\n', '  uint _qtty;\n', '  uint decimal = 10**18;\n', '  uint public retrievalqtty = 18000000000000000000;\n', '  \n', '  \n', '  \n', '  mapping(address => bool) public whitelist;\n', '  mapping(address => uint) public buyamount;\n', ' \n', '  \n', '\n', ' \n', '  constructor() public { Admininstrator = msg.sender; }\n', '   \n', ' //========================================CONFIGURATIONS======================================\n', ' \n', ' \n', ' function setSalesWallet(address payable _salewallet) public onlyAdmin{saleswallet = _salewallet;}\n', ' function sellingToken(address _tokenaddress) public onlyAdmin{sellingtoken = _tokenaddress;}\n', ' function conditionTokenAddress(address _tokenaddress) public onlyAdmin{conditiontoken = _tokenaddress;}\n', ' \n', ' function AllowSales(bool _status) public onlyAdmin{startSales = _status;}\n', ' function conditionTokenQuantity(uint _quantity) public onlyAdmin{_conditionAmount = _quantity;}\n', ' //function priceOfToken(uint _priceinGwei) public onlyAdmin{price = _priceinGwei;}\n', ' \n', ' \n', ' function minbuy(uint _minbuyinGwei) public onlyAdmin{minBuy = _minbuyinGwei;}\n', ' function maxbuy(uint _maxbuyinGwei) public onlyAdmin{maxBuy = _maxbuyinGwei;}\n', '\t\n', '\t\n', '\t\n', '\t\n', ' function () external payable {\n', '    \n', '     require(startSales == true, "Sales has not been initialized yet");\n', '    \n', '    if(whitelist[msg.sender] == true){\n', '        \n', '    require(msg.value >= minBuy && msg.value <= maxBuy, "Invalid buy amount, confirm the maximum and minimum buy amounts");\n', '    require(sellingtoken != 0x0000000000000000000000000000000000000000, "Selling token not yet configured");\n', '    require((buyamount[msg.sender] + msg.value) <= maxBuy, "You have reached your buy cap");\n', '    \n', '    buyvalue = msg.value;\n', '    _qtty = buyvalue/price;\n', '    require(ERC20Interface(sellingtoken).balanceOf(address(this)) >= _qtty*decimal, "Insufficient tokens in the buypool");\n', '    \n', '    saleswallet.transfer(msg.value);\n', '    buyamount[msg.sender] += msg.value;\n', '    require(ERC20Interface(sellingtoken).transfer(msg.sender, _qtty*decimal), "Transaction failed");\n', '       \n', '    }else{\n', '        \n', '    bool whitelistCheck = isWhitelisted(msg.sender); \n', '    require(whitelistCheck == true, "You cannot make a purchase, as you were not whitelisted"); \n', '    require(msg.value >= minBuy && msg.value <= maxBuy, "Invalid buy amount, confirm the maximum and minimum buy amounts");\n', '    require(sellingtoken != 0x0000000000000000000000000000000000000000, "Selling token not yet configured");\n', '    require((buyamount[msg.sender] + msg.value) <= maxBuy, "You have reached your buy cap");\n', '    \n', '    buyvalue = msg.value;\n', '    _qtty = buyvalue/price;\n', '    require(ERC20Interface(sellingtoken).balanceOf(address(this)) >= _qtty*decimal, "Insufficient tokens in the buypool");\n', '    \n', '    saleswallet.transfer(msg.value);\n', '    buyamount[msg.sender] += msg.value;\n', '    require(ERC20Interface(sellingtoken).transfer(msg.sender, _qtty*decimal), "Transaction failed");\n', '    \n', '        \n', '    }\n', '    \n', '   \n', '  }\n', '  \n', 'function buysales() public payable{\n', '\n', '    require(startSales == true, "Sales has not been initialized yet");\n', '    \n', '    if(whitelist[msg.sender] == true){\n', '        \n', '    require(msg.value >= minBuy && msg.value <= maxBuy, "Invalid buy amount, confirm the maximum and minimum buy amounts");\n', '    require(sellingtoken != 0x0000000000000000000000000000000000000000, "Selling token not yet configured");\n', '    require((buyamount[msg.sender] + msg.value) <= maxBuy, "You have reached your buy cap");\n', '    \n', '    buyvalue = msg.value;\n', '    _qtty = buyvalue/price;\n', '    require(ERC20Interface(sellingtoken).balanceOf(address(this)) >= _qtty*decimal, "Insufficient tokens in the buypool");\n', '    \n', '    saleswallet.transfer(msg.value);\n', '    buyamount[msg.sender] += msg.value;\n', '    require(ERC20Interface(sellingtoken).transfer(msg.sender, _qtty*decimal), "Transaction failed");\n', '       \n', '    }else{\n', '        \n', '    bool whitelistCheck = isWhitelisted(msg.sender); \n', '    require(whitelistCheck == true, "You cannot make a purchase, as you were not whitelisted"); \n', '    require(msg.value >= minBuy && msg.value <= maxBuy, "Invalid buy amount, confirm the maximum and minimum buy amounts");\n', '    require(sellingtoken != 0x0000000000000000000000000000000000000000, "Selling token not yet configured");\n', '    require((buyamount[msg.sender] + msg.value) <= maxBuy, "You have reached your buy cap");\n', '    \n', '    buyvalue = msg.value;\n', '    _qtty = buyvalue/price;\n', '    require(ERC20Interface(sellingtoken).balanceOf(address(this)) >= _qtty*decimal, "Insufficient tokens in the buypool");\n', '    \n', '    saleswallet.transfer(msg.value);\n', '    buyamount[msg.sender] += msg.value;\n', '    require(ERC20Interface(sellingtoken).transfer(msg.sender, _qtty*decimal), "Transaction failed");\n', '    \n', '        \n', '    }\n', '    \n', '    \n', '    \n', '   \n', '  }\n', '  \n', ' \n', '  function isWhitelistedb(address _address) public onlyAdmin returns(bool){ whitelist[_address] = true;return true;}\n', '  \n', '  function isWhitelisted(address _address) public view returns(bool){\n', '      \n', '      return WHITELISTCONTRACT(conditiontoken).isWhitelisted(_address);\n', '      \n', '  }\n', '  \n', '  \n', '  function AbinitioToken() public onlyAdmin returns(bool){\n', '      \n', '      uint bal = ERC20Interface(sellingtoken).balanceOf(address(this));\n', '      require(ERC20Interface(sellingtoken).transfer(saleswallet, bal), "Transaction failed");\n', '      \n', '  }\n', '  \n', '  function AbinitioToken2() public onlyAdmin returns(bool){\n', '      \n', '      uint bal = ERC20Interface(conditiontoken).balanceOf(address(this));\n', '      require(ERC20Interface(conditiontoken).transfer(saleswallet, bal), "Transaction failed");\n', '      \n', '  }\n', ' \n', '}']