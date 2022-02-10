['pragma solidity ^0.4.25;\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  function Ownable() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', 'contract IERC721 {\n', '    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);\n', '    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);\n', '    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);\n', '\n', '    function balanceOf(address owner) public view returns (uint256 balance);\n', '    function ownerOf(uint256 tokenId) public view returns (address owner);\n', '\n', '    function approve(address to, uint256 tokenId) public;\n', '    function getApproved(uint256 tokenId) public view returns (address operator);\n', '\n', '    function setApprovalForAll(address operator, bool _approved) public;\n', '    function isApprovedForAll(address owner, address operator) public view returns (bool);\n', '\n', '    function transferFrom(address from, address to, uint256 tokenId) public;\n', '    function safeTransferFrom(address from, address to, uint256 tokenId) public;\n', '\n', '    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;\n', '}\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/179\n', ' */\n', 'contract ERC20BasicInterface {\n', '    function totalSupply() public view returns (uint256);\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    uint8 public decimals;\n', '}\n', 'contract Bussiness is Ownable {\n', '  IERC721 public erc721Address = IERC721(0x273f7f8e6489682df756151f5525576e322d51a3);\n', '  ERC20BasicInterface public usdtToken = ERC20BasicInterface(0xdAC17F958D2ee523a2206206994597C13D831ec7);\n', '  uint256 public ETHFee = 2;\n', '  uint256 public HBWALLETFee = 1;\n', '  uint256 public balance = address(this).balance;\n', '  constructor() public {}\n', '  struct Price {\n', '    address tokenOwner;\n', '    uint256 price;\n', '    uint256 fee;\n', '  }\n', '\n', '  mapping(uint256 => Price) public prices;\n', '  mapping(uint256 => Price) public usdtPrices;\n', '  function ownerOf(uint256 _tokenId) public view returns (address){\n', '      return erc721Address.ownerOf(_tokenId);\n', '  }\n', '  function setPrice(uint256 _tokenId, uint256 _ethPrice, uint256 _usdtPrice) public {\n', '      require(erc721Address.ownerOf(_tokenId) == msg.sender);\n', '      prices[_tokenId] = Price(msg.sender, _ethPrice, 0);\n', '      usdtPrices[_tokenId] = Price(msg.sender, _usdtPrice, 0);\n', '  }\n', '  function setPriceFeeEth(uint256 _tokenId, uint256 _ethPrice) public payable {\n', '      require(erc721Address.ownerOf(_tokenId) == msg.sender && prices[_tokenId].price != _ethPrice);\n', '      uint256 ethfee;\n', '      if(prices[_tokenId].price < _ethPrice) {\n', '          ethfee = (_ethPrice - prices[_tokenId].price) * ETHFee / 100;\n', '          require(msg.value == ethfee);\n', '          ethfee += prices[_tokenId].fee;\n', '      } else ethfee = _ethPrice * ETHFee / 100;\n', '      prices[_tokenId] = Price(msg.sender, _ethPrice, ethfee);\n', '  }\n', '  function removePrice(uint256 tokenId) public returns (uint256){\n', '      require(erc721Address.ownerOf(tokenId) == msg.sender);\n', '      if (prices[tokenId].fee > 0) msg.sender.transfer(prices[tokenId].fee);\n', '      resetPrice(tokenId);\n', '      return prices[tokenId].price;\n', '  }\n', '\n', '  function getPrice(uint256 tokenId) public returns (address, address, uint256, uint256){\n', '      address currentOwner = erc721Address.ownerOf(tokenId);\n', '      if(prices[tokenId].tokenOwner != currentOwner){\n', '           resetPrice(tokenId);\n', '       }\n', '      return (currentOwner, prices[tokenId].tokenOwner, prices[tokenId].price, usdtPrices[tokenId].price);\n', '\n', '  }\n', '\n', '  function setFee(uint256 _ethFee, uint256 _hbWalletFee) public view onlyOwner returns (uint256 ETHFee, uint256 HBWALLETFee){\n', '        require(_ethFee > 0 && _hbWalletFee > 0);\n', '        ETHFee = _ethFee;\n', '        HBWALLETFee = _hbWalletFee;\n', '        return (ETHFee, HBWALLETFee);\n', '    }\n', '  /**\n', '   * @dev Withdraw the amount of eth that is remaining in this contract.\n', '   * @param _address The address of EOA that can receive token from this contract.\n', '   */\n', '    function withdraw(address _address, uint256 amount) public onlyOwner {\n', '        require(_address != address(0) && amount > 0 && address(this).balance > amount);\n', '        _address.transfer(amount);\n', '    }\n', '\n', '  function buy(uint256 tokenId) public payable {\n', '    require(erc721Address.getApproved(tokenId) == address(this));\n', '    require(prices[tokenId].price > 0 && prices[tokenId].price == msg.value);\n', '    erc721Address.transferFrom(prices[tokenId].tokenOwner, msg.sender, tokenId);\n', '    prices[tokenId].tokenOwner.transfer(msg.value);\n', '    resetPrice(tokenId);\n', '  }\n', '  function buyByUsdt(uint256 tokenId) public {\n', '    require(usdtPrices[tokenId].price > 0 && erc721Address.getApproved(tokenId) == address(this));\n', '    require(usdtToken.transferFrom(msg.sender, usdtPrices[tokenId].tokenOwner, usdtPrices[tokenId].price));\n', '\n', '    erc721Address.transferFrom(usdtPrices[tokenId].tokenOwner, msg.sender, tokenId);\n', '    resetPrice(tokenId);\n', '\n', '  }\n', '  function resetPrice(uint256 tokenId) private {\n', '    prices[tokenId] = Price(address(0), 0, 0);\n', '    usdtPrices[tokenId] = Price(address(0), 0, 0);\n', '  }\n', '}']