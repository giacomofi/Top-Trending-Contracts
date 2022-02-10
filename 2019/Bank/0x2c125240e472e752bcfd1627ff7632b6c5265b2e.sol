['pragma solidity ^0.4.25;\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', 'contract IERC721 {\n', '    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);\n', '    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);\n', '    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);\n', '\n', '    function balanceOf(address owner) public view returns (uint256 balance);\n', '    function ownerOf(uint256 tokenId) public view returns (address owner);\n', '\n', '    function approve(address to, uint256 tokenId) public;\n', '    function getApproved(uint256 tokenId) public view returns (address operator);\n', '\n', '    function setApprovalForAll(address operator, bool _approved) public;\n', '    function isApprovedForAll(address owner, address operator) public view returns (bool);\n', '\n', '    function transferFrom(address from, address to, uint256 tokenId) public;\n', '    function safeTransferFrom(address from, address to, uint256 tokenId) public;\n', '\n', '    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;\n', '}\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20BasicInterface {\n', '    function totalSupply() public view returns (uint256);\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    uint8 public decimals;\n', '}\n', 'contract Bussiness is Ownable {\n', '  address public ceoAddress = address(0x6c3e879bdd20e9686cfd9bbd1bfd4b2dd6d47079);\n', '  IERC721 public erc721Address = IERC721(0x06012c8cf97bead5deae237070f9587f8e7a266d);\n', '  ERC20BasicInterface public usdtToken = ERC20BasicInterface(0x315f396592c3c8a2d96d62fb597e2bf4fa7734ab);\n', '  ERC20BasicInterface public hbwalletToken = ERC20BasicInterface(0xEc7ba74789694d0d03D458965370Dc7cF2FE75Ba);\n', '  uint256 public ETHFee = 25; // 2,5 %\n', '  uint256 public Percen = 1000;\n', '  uint256 public HBWALLETExchange = 21;\n', '  // cong thuc hbFee = ETHFee / Percen * HBWALLETExchange / 2\n', '  uint256 public limitETHFee = 2000000000000000;\n', '  uint256 public limitHBWALLETFee = 2;\n', '  constructor() public {}\n', '  struct Price {\n', '    address tokenOwner;\n', '    uint256 price;\n', '    uint256 fee;\n', '    uint256 hbfee;\n', '  }\n', '\n', '  mapping(uint256 => Price) public prices;\n', '  mapping(uint256 => Price) public usdtPrices;\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the ceo address.\n', '   */\n', '  modifier onlyCeoAddress() {\n', '    require(msg.sender == ceoAddress);\n', '    _;\n', '  }\n', '  function ownerOf(uint256 _tokenId) public view returns (address){\n', '      return erc721Address.ownerOf(_tokenId);\n', '  }\n', '  function balanceOf() public view returns (uint256){\n', '      return address(this).balance;\n', '  }\n', '  function getApproved(uint256 _tokenId) public view returns (address){\n', '      return erc721Address.getApproved(_tokenId);\n', '  }\n', '\n', '  function setPrice(uint256 _tokenId, uint256 _ethPrice, uint256 _usdtPrice) public {\n', '      require(erc721Address.ownerOf(_tokenId) == msg.sender);\n', '      prices[_tokenId] = Price(msg.sender, _ethPrice, 0, 0);\n', '      usdtPrices[_tokenId] = Price(msg.sender, _usdtPrice, 0, 0);\n', '  }\n', '  function setPriceFeeEth(uint256 _tokenId, uint256 _ethPrice) public payable {\n', '      require(erc721Address.ownerOf(_tokenId) == msg.sender && prices[_tokenId].price != _ethPrice);\n', '      uint256 ethfee;\n', '      if(prices[_tokenId].price < _ethPrice) {\n', '          ethfee = (_ethPrice - prices[_tokenId].price) * ETHFee / Percen;\n', '          if(ethfee >= limitETHFee) {\n', '              require(msg.value == ethfee);\n', '          } else {\n', '              require(msg.value == limitETHFee);\n', '          }\n', '          ethfee += prices[_tokenId].fee;\n', '      } else ethfee = _ethPrice * ETHFee / Percen;\n', '      prices[_tokenId] = Price(msg.sender, _ethPrice, ethfee, 0);\n', '  }\n', '  function setPriceFeeHBWALLETTest(uint256 _tokenId, uint256 _ethPrice) public view returns (uint256, uint256){\n', '      uint256 ethfee = _ethPrice * ETHFee / Percen;\n', '      return (ethfee, ethfee * HBWALLETExchange / 2 / (10 ** 16)); // ethfee / (10 ** 18) * HBWALLETExchange / 2 * (10 ** 2)\n', '  }\n', '  function setPriceFeeHBWALLET(uint256 _tokenId, uint256 _ethPrice) public returns (bool){\n', '      require(erc721Address.ownerOf(_tokenId) == msg.sender && prices[_tokenId].price != _ethPrice);\n', '      uint256 fee;\n', '      uint256 ethfee;\n', '      if(prices[_tokenId].price < _ethPrice) {\n', '          ethfee = (_ethPrice - prices[_tokenId].price) * ETHFee / Percen;\n', '          fee = ethfee * HBWALLETExchange / 2 / (10 ** 16); // ethfee * HBWALLETExchange / 2 * (10 ** 2) / (10 ** 18)\n', '          if(fee >= limitHBWALLETFee) {\n', '              require(hbwalletToken.transferFrom(msg.sender, address(this), fee));\n', '          } else {\n', '              require(hbwalletToken.transferFrom(msg.sender, address(this), limitHBWALLETFee));\n', '          }\n', '          fee += prices[_tokenId].hbfee;\n', '      } else {\n', '          ethfee = _ethPrice * ETHFee / Percen;\n', '          fee = ethfee * HBWALLETExchange / 2 / (10 ** 16);\n', '      }\n', '      prices[_tokenId] = Price(msg.sender, _ethPrice, 0, fee);\n', '      return true;\n', '  }\n', '  function removePrice(uint256 tokenId) public returns (uint256){\n', '      require(erc721Address.ownerOf(tokenId) == msg.sender);\n', '      if (prices[tokenId].fee > 0) msg.sender.transfer(prices[tokenId].fee);\n', '      else if (prices[tokenId].hbfee > 0) hbwalletToken.transfer(msg.sender, prices[tokenId].hbfee);\n', '      resetPrice(tokenId);\n', '      return prices[tokenId].price;\n', '  }\n', '\n', '  function getPrice(uint256 tokenId) public view returns (address, address, uint256, uint256){\n', '      address currentOwner = erc721Address.ownerOf(tokenId);\n', '      if(prices[tokenId].tokenOwner != currentOwner){\n', '           resetPrice(tokenId);\n', '       }\n', '      return (currentOwner, prices[tokenId].tokenOwner, prices[tokenId].price, usdtPrices[tokenId].price);\n', '\n', '  }\n', '\n', '  function setFee(uint256 _ethFee, uint256 _HBWALLETExchange) public view onlyOwner returns (uint256, uint256){\n', '        require(_ethFee > 0 && _HBWALLETExchange > 0);\n', '        ETHFee = _ethFee;\n', '        HBWALLETExchange = _HBWALLETExchange;\n', '        return (ETHFee, HBWALLETExchange);\n', '    }\n', '    function setLimitFee(uint256 _ethlimitFee, uint256 _hbWalletlimitFee) public view onlyOwner returns (uint256, uint256){\n', '        require(_ethlimitFee > 0 && _hbWalletlimitFee > 0);\n', '        limitETHFee = _ethlimitFee;\n', '        limitHBWALLETFee = _hbWalletlimitFee;\n', '        return (limitETHFee, limitHBWALLETFee);\n', '    }\n', '  /**\n', '   * @dev Withdraw the amount of eth that is remaining in this contract.\n', '   * @param _address The address of EOA that can receive token from this contract.\n', '   */\n', '    function withdraw(address _address, uint256 amount) public onlyCeoAddress {\n', '        require(_address != address(0) && amount > 0 && address(this).balance > amount);\n', '        _address.transfer(amount);\n', '    }\n', '\n', '  function buy(uint256 tokenId) public payable {\n', '    require(getApproved(tokenId) == address(this));\n', '    require(prices[tokenId].price > 0 && prices[tokenId].price == msg.value);\n', '    erc721Address.transferFrom(prices[tokenId].tokenOwner, msg.sender, tokenId);\n', '    prices[tokenId].tokenOwner.transfer(msg.value);\n', '    resetPrice(tokenId);\n', '  }\n', '  function buyByUsdt(uint256 tokenId) public {\n', '    require(usdtPrices[tokenId].price > 0 && erc721Address.getApproved(tokenId) == address(this));\n', '    require(usdtToken.transferFrom(msg.sender, usdtPrices[tokenId].tokenOwner, usdtPrices[tokenId].price));\n', '\n', '    erc721Address.transferFrom(usdtPrices[tokenId].tokenOwner, msg.sender, tokenId);\n', '    resetPrice(tokenId);\n', '\n', '  }\n', '  function resetPrice(uint256 tokenId) private {\n', '    prices[tokenId] = Price(address(0), 0, 0, 0);\n', '    usdtPrices[tokenId] = Price(address(0), 0, 0, 0);\n', '  }\n', '}']