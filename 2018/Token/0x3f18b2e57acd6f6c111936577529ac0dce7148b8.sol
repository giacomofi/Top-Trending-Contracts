['pragma solidity ^0.4.23;\n', '\n', '/**\n', ' * @title ERC721 Non-Fungible Token Standard basic interface\n', ' * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md\n', ' */\n', 'contract ERC721Basic {\n', '  event Transfer(\n', '    address indexed _from,\n', '    address indexed _to,\n', '    uint256 _tokenId\n', '  );\n', '  event Approval(\n', '    address indexed _owner,\n', '    address indexed _approved,\n', '    uint256 _tokenId\n', '  );\n', '  event ApprovalForAll(\n', '    address indexed _owner,\n', '    address indexed _operator,\n', '    bool _approved\n', '  );\n', '\n', '  function balanceOf(address _owner) public view returns (uint256 _balance);\n', '  function ownerOf(uint256 _tokenId) public view returns (address _owner);\n', '  function exists(uint256 _tokenId) public view returns (bool _exists);\n', '\n', '  function approve(address _to, uint256 _tokenId) public;\n', '  function getApproved(uint256 _tokenId)\n', '    public view returns (address _operator);\n', '\n', '  function setApprovalForAll(address _operator, bool _approved) public;\n', '  function isApprovedForAll(address _owner, address _operator)\n', '    public view returns (bool);\n', '\n', '  function transferFrom(address _from, address _to, uint256 _tokenId) public;\n', '  function safeTransferFrom(address _from, address _to, uint256 _tokenId)\n', '    public;\n', '\n', '  function safeTransferFrom(\n', '    address _from,\n', '    address _to,\n', '    uint256 _tokenId,\n', '    bytes _data\n', '  )\n', '    public;\n', '}\n', '\n', '/**\n', ' * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension\n', ' * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md\n', ' */\n', 'contract ERC721Enumerable is ERC721Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function tokenOfOwnerByIndex(\n', '    address _owner,\n', '    uint256 _index\n', '  )\n', '    public\n', '    view\n', '    returns (uint256 _tokenId);\n', '\n', '  function tokenByIndex(uint256 _index) public view returns (uint256);\n', '}\n', '\n', '/**\n', ' * @title ERC-721 Non-Fungible Token Standard, optional metadata extension\n', ' * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md\n', ' */\n', 'contract ERC721Metadata is ERC721Basic {\n', '  function name() public view returns (string _name);\n', '  function symbol() public view returns (string _symbol);\n', '  function tokenURI(uint256 _tokenId) public view returns (string);\n', '}\n', '\n', '/**\n', ' * @title ERC-721 Non-Fungible Token Standard, full implementation interface\n', ' * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md\n', ' */\n', 'contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipRenounced(address indexed previousOwner);\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to relinquish control of the contract.\n', '   */\n', '  function renounceOwnership() public onlyOwner {\n', '    emit OwnershipRenounced(owner);\n', '    owner = address(0);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address _newOwner) public onlyOwner {\n', '    _transferOwnership(_newOwner);\n', '  }\n', '\n', '  /**\n', '   * @dev Transfers control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function _transferOwnership(address _newOwner) internal {\n', '    require(_newOwner != address(0));\n', '    emit OwnershipTransferred(owner, _newOwner);\n', '    owner = _newOwner;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    emit Pause();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    emit Unpause();\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Destructible\n', ' * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.\n', ' */\n', 'contract Destructible is Ownable {\n', '\n', '  constructor() public payable { }\n', '\n', '  /**\n', '   * @dev Transfers the current balance to the owner and terminates the contract.\n', '   */\n', '  function destroy() onlyOwner public {\n', '    selfdestruct(owner);\n', '  }\n', '\n', '  function destroyAndSend(address _recipient) onlyOwner public {\n', '    selfdestruct(_recipient);\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title CryptoArteSales\n', ' * CryptoArteSales - a sales contract for CryptoArte non-fungible tokens \n', ' * corresponding to paintings from the www.cryptoarte.io collection\n', ' */\n', 'contract CryptoArteSales is Ownable, Pausable, Destructible {\n', '\n', '    event Sent(address indexed payee, uint256 amount, uint256 balance);\n', '    event Received(address indexed payer, uint tokenId, uint256 amount, uint256 balance);\n', '\n', '    ERC721 public nftAddress;\n', '    uint256 public currentPrice;\n', '\n', '    /**\n', '    * @dev Contract Constructor\n', '    * @param _nftAddress address for Crypto Arte non-fungible token contract \n', '    * @param _currentPrice initial sales price\n', '    */\n', '    constructor(address _nftAddress, uint256 _currentPrice) public { \n', '        require(_nftAddress != address(0) && _nftAddress != address(this));\n', '        require(_currentPrice > 0);\n', '        nftAddress = ERC721(_nftAddress);\n', '        currentPrice = _currentPrice;\n', '    }\n', '\n', '    /**\n', '    * @dev Purchase _tokenId\n', '    * @param _tokenId uint256 token ID (painting number)\n', '    */\n', '    function purchaseToken(uint256 _tokenId) public payable whenNotPaused {\n', '        require(msg.sender != address(0) && msg.sender != address(this));\n', '        require(msg.value >= currentPrice);\n', '        require(nftAddress.exists(_tokenId));\n', '        address tokenSeller = nftAddress.ownerOf(_tokenId);\n', '        nftAddress.safeTransferFrom(tokenSeller, msg.sender, _tokenId);\n', '        emit Received(msg.sender, _tokenId, msg.value, address(this).balance);\n', '    }\n', '\n', '    /**\n', '    * @dev send / withdraw _amount to _payee\n', '    */\n', '    function sendTo(address _payee, uint256 _amount) public onlyOwner {\n', '        require(_payee != address(0) && _payee != address(this));\n', '        require(_amount > 0 && _amount <= address(this).balance);\n', '        _payee.transfer(_amount);\n', '        emit Sent(_payee, _amount, address(this).balance);\n', '    }    \n', '\n', '    /**\n', '    * @dev Updates _currentPrice\n', '    * @dev Throws if _currentPrice is zero\n', '    */\n', '    function setCurrentPrice(uint256 _currentPrice) public onlyOwner {\n', '        require(_currentPrice > 0);\n', '        currentPrice = _currentPrice;\n', '    }        \n', '\n', '}']
['pragma solidity ^0.4.23;\n', '\n', '/**\n', ' * @title ERC721 Non-Fungible Token Standard basic interface\n', ' * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md\n', ' */\n', 'contract ERC721Basic {\n', '  event Transfer(\n', '    address indexed _from,\n', '    address indexed _to,\n', '    uint256 _tokenId\n', '  );\n', '  event Approval(\n', '    address indexed _owner,\n', '    address indexed _approved,\n', '    uint256 _tokenId\n', '  );\n', '  event ApprovalForAll(\n', '    address indexed _owner,\n', '    address indexed _operator,\n', '    bool _approved\n', '  );\n', '\n', '  function balanceOf(address _owner) public view returns (uint256 _balance);\n', '  function ownerOf(uint256 _tokenId) public view returns (address _owner);\n', '  function exists(uint256 _tokenId) public view returns (bool _exists);\n', '\n', '  function approve(address _to, uint256 _tokenId) public;\n', '  function getApproved(uint256 _tokenId)\n', '    public view returns (address _operator);\n', '\n', '  function setApprovalForAll(address _operator, bool _approved) public;\n', '  function isApprovedForAll(address _owner, address _operator)\n', '    public view returns (bool);\n', '\n', '  function transferFrom(address _from, address _to, uint256 _tokenId) public;\n', '  function safeTransferFrom(address _from, address _to, uint256 _tokenId)\n', '    public;\n', '\n', '  function safeTransferFrom(\n', '    address _from,\n', '    address _to,\n', '    uint256 _tokenId,\n', '    bytes _data\n', '  )\n', '    public;\n', '}\n', '\n', '/**\n', ' * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension\n', ' * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md\n', ' */\n', 'contract ERC721Enumerable is ERC721Basic {\n', '  function totalSupply() public view returns (uint256);\n', '  function tokenOfOwnerByIndex(\n', '    address _owner,\n', '    uint256 _index\n', '  )\n', '    public\n', '    view\n', '    returns (uint256 _tokenId);\n', '\n', '  function tokenByIndex(uint256 _index) public view returns (uint256);\n', '}\n', '\n', '/**\n', ' * @title ERC-721 Non-Fungible Token Standard, optional metadata extension\n', ' * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md\n', ' */\n', 'contract ERC721Metadata is ERC721Basic {\n', '  function name() public view returns (string _name);\n', '  function symbol() public view returns (string _symbol);\n', '  function tokenURI(uint256 _tokenId) public view returns (string);\n', '}\n', '\n', '/**\n', ' * @title ERC-721 Non-Fungible Token Standard, full implementation interface\n', ' * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md\n', ' */\n', 'contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipRenounced(address indexed previousOwner);\n', '  event OwnershipTransferred(\n', '    address indexed previousOwner,\n', '    address indexed newOwner\n', '  );\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to relinquish control of the contract.\n', '   */\n', '  function renounceOwnership() public onlyOwner {\n', '    emit OwnershipRenounced(owner);\n', '    owner = address(0);\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address _newOwner) public onlyOwner {\n', '    _transferOwnership(_newOwner);\n', '  }\n', '\n', '  /**\n', '   * @dev Transfers control of the contract to a newOwner.\n', '   * @param _newOwner The address to transfer ownership to.\n', '   */\n', '  function _transferOwnership(address _newOwner) internal {\n', '    require(_newOwner != address(0));\n', '    emit OwnershipTransferred(owner, _newOwner);\n', '    owner = _newOwner;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    emit Pause();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    emit Unpause();\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Destructible\n', ' * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.\n', ' */\n', 'contract Destructible is Ownable {\n', '\n', '  constructor() public payable { }\n', '\n', '  /**\n', '   * @dev Transfers the current balance to the owner and terminates the contract.\n', '   */\n', '  function destroy() onlyOwner public {\n', '    selfdestruct(owner);\n', '  }\n', '\n', '  function destroyAndSend(address _recipient) onlyOwner public {\n', '    selfdestruct(_recipient);\n', '  }\n', '}\n', '\n', '\n', '/**\n', ' * @title CryptoArteSales\n', ' * CryptoArteSales - a sales contract for CryptoArte non-fungible tokens \n', ' * corresponding to paintings from the www.cryptoarte.io collection\n', ' */\n', 'contract CryptoArteSales is Ownable, Pausable, Destructible {\n', '\n', '    event Sent(address indexed payee, uint256 amount, uint256 balance);\n', '    event Received(address indexed payer, uint tokenId, uint256 amount, uint256 balance);\n', '\n', '    ERC721 public nftAddress;\n', '    uint256 public currentPrice;\n', '\n', '    /**\n', '    * @dev Contract Constructor\n', '    * @param _nftAddress address for Crypto Arte non-fungible token contract \n', '    * @param _currentPrice initial sales price\n', '    */\n', '    constructor(address _nftAddress, uint256 _currentPrice) public { \n', '        require(_nftAddress != address(0) && _nftAddress != address(this));\n', '        require(_currentPrice > 0);\n', '        nftAddress = ERC721(_nftAddress);\n', '        currentPrice = _currentPrice;\n', '    }\n', '\n', '    /**\n', '    * @dev Purchase _tokenId\n', '    * @param _tokenId uint256 token ID (painting number)\n', '    */\n', '    function purchaseToken(uint256 _tokenId) public payable whenNotPaused {\n', '        require(msg.sender != address(0) && msg.sender != address(this));\n', '        require(msg.value >= currentPrice);\n', '        require(nftAddress.exists(_tokenId));\n', '        address tokenSeller = nftAddress.ownerOf(_tokenId);\n', '        nftAddress.safeTransferFrom(tokenSeller, msg.sender, _tokenId);\n', '        emit Received(msg.sender, _tokenId, msg.value, address(this).balance);\n', '    }\n', '\n', '    /**\n', '    * @dev send / withdraw _amount to _payee\n', '    */\n', '    function sendTo(address _payee, uint256 _amount) public onlyOwner {\n', '        require(_payee != address(0) && _payee != address(this));\n', '        require(_amount > 0 && _amount <= address(this).balance);\n', '        _payee.transfer(_amount);\n', '        emit Sent(_payee, _amount, address(this).balance);\n', '    }    \n', '\n', '    /**\n', '    * @dev Updates _currentPrice\n', '    * @dev Throws if _currentPrice is zero\n', '    */\n', '    function setCurrentPrice(uint256 _currentPrice) public onlyOwner {\n', '        require(_currentPrice > 0);\n', '        currentPrice = _currentPrice;\n', '    }        \n', '\n', '}']
