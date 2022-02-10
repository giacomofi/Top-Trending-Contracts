['pragma solidity ^0.4.23;\n', '\n', '// File: contracts/convert/ByteConvert.sol\n', '\n', 'library ByteConvert {\n', '\n', '  function bytesToBytes2(bytes b) public pure returns (bytes2) {\n', '    bytes2 out;\n', '    for (uint i = 0; i < 2; i++) {\n', '      out |= bytes2(b[i] & 0xFF) >> (i * 8);\n', '    }\n', '    return out;\n', '  }\n', '\n', '  function bytesToBytes5(bytes b) public pure returns (bytes5) {\n', '    bytes5 out;\n', '    for (uint i = 0; i < 5; i++) {\n', '      out |= bytes5(b[i] & 0xFF) >> (i * 8);\n', '    }\n', '    return out;\n', '  }\n', '\n', '  function bytesToBytes8(bytes b) public pure returns (bytes8) {\n', '    bytes8 out;\n', '    for (uint i = 0; i < 8; i++) {\n', '      out |= bytes8(b[i] & 0xFF) >> (i * 8);\n', '    }\n', '    return out;\n', '  }\n', '\n', '}\n', '\n', '// File: contracts/interface/EtherSpaceBattleInterface.sol\n', '\n', 'contract EtherSpaceBattleInterface {\n', '  function isEtherSpaceBattle() public pure returns (bool);\n', '  function battle(bytes8 _spaceshipAttributes, bytes5 _spaceshipUpgrades, bytes8 _spaceshipToAttackAttributes, bytes5 _spaceshipToAttackUpgrades) public returns (bool);\n', '  function calculateStake(bytes8 _spaceshipAttributes, bytes5 _spaceshipUpgrades) public pure returns (uint256);\n', '  function calculateLevel(bytes8 _spaceshipAttributes, bytes5 _spaceshipUpgrades) public pure returns (uint256);\n', '}\n', '\n', '// File: contracts/interface/EtherSpaceUpgradeInterface.sol\n', '\n', 'contract EtherSpaceUpgradeInterface {\n', '  function isEtherSpaceUpgrade() public pure returns (bool);\n', '  function isSpaceshipUpgradeAllowed(bytes5 _upgrades, uint16 _upgradeId, uint8 _position) public view;\n', '  function buySpaceshipUpgrade(bytes5 _upgrades, uint16 _model, uint8 _position) public returns (bytes5);\n', '  function getSpaceshipUpgradePriceByModel(uint16 _model, uint8 _position) public view returns (uint256);\n', '  function getSpaceshipUpgradeTotalSoldByModel(uint16 _model, uint8 _position) public view returns (uint256);\n', '  function getSpaceshipUpgradeCount() public view returns (uint256);\n', '  function newSpaceshipUpgrade(bytes1 _identifier, uint8 _position, uint256 _price) public;\n', '}\n', '\n', '// File: contracts/ownership/Ownable.sol\n', '\n', '// Courtesy of the Zeppelin project (https://github.com/OpenZeppelin/zeppelin-solidity)\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '\n', '    address public owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '    * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '    * account.\n', '    */\n', '    constructor() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    /**\n', '    * @dev Throws if called by any account other than the owner.\n', '    */\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '    * @param newOwner The address to transfer ownership to.\n', '    */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '\n', '\n', '}\n', '\n', '// File: contracts/lifecycle/Destructible.sol\n', '\n', '// Courtesy of the Zeppelin project (https://github.com/OpenZeppelin/zeppelin-solidity)\n', '\n', '/**\n', ' * @title Destructible\n', ' * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.\n', ' */\n', 'contract Destructible is Ownable {\n', '\n', '    constructor() public payable { }\n', '\n', '    /**\n', '    * @dev Transfers the current balance to the owner and terminates the contract.\n', '    */\n', '    function destroy() onlyOwner public {\n', '        selfdestruct(owner);\n', '    }\n', '\n', '    function destroyAndSend(address _recipient) onlyOwner public {\n', '        selfdestruct(_recipient);\n', '    }\n', '\n', '}\n', '\n', '// File: contracts/math/SafeMath.sol\n', '\n', '// Courtesy of the Zeppelin project (https://github.com/OpenZeppelin/zeppelin-solidity)\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '\n', '}\n', '\n', '// File: contracts/ownership/Claimable.sol\n', '\n', '// Courtesy of the Zeppelin project (https://github.com/OpenZeppelin/zeppelin-solidity)\n', '\n', '/**\n', ' * @title Claimable\n', ' * @dev Extension for the Ownable contract, where the ownership needs to be claimed.\n', ' * This allows the new owner to accept the transfer.\n', ' */\n', 'contract Claimable is Ownable {\n', '\n', '    address public pendingOwner;\n', '\n', '    /**\n', '    * @dev Modifier throws if called by any account other than the pendingOwner.\n', '    */\n', '    modifier onlyPendingOwner() {\n', '        require(msg.sender == pendingOwner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev Allows the current owner to set the pendingOwner address.\n', '    * @param newOwner The address to transfer ownership to.\n', '    */\n', '    function transferOwnership(address newOwner) onlyOwner public {\n', '        pendingOwner = newOwner;\n', '    }\n', '\n', '    /**\n', '    * @dev Allows the pendingOwner address to finalize the transfer.\n', '    */\n', '    function claimOwnership() onlyPendingOwner public {\n', '        emit OwnershipTransferred(owner, pendingOwner);\n', '        owner = pendingOwner;\n', '        pendingOwner = address(0);\n', '    }\n', '\n', '}\n', '\n', '// File: contracts/token/ERC721.sol\n', '\n', '/**\n', ' * @title ERC721 interface\n', ' * @dev see https://github.com/ethereum/eips/issues/721\n', ' */\n', 'contract ERC721 {\n', '  event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);\n', '  event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);\n', '\n', '  function balanceOf(address _owner) public view returns (uint256 _balance);\n', '  function ownerOf(uint256 _tokenId) public view returns (address _owner);\n', '  function transfer(address _to, uint256 _tokenId) public;\n', '  function approve(address _to, uint256 _tokenId) public;\n', '  function takeOwnership(uint256 _tokenId) public;\n', '}\n', '\n', '// File: contracts/token/ERC721Token.sol\n', '\n', '/**\n', ' * @title ERC721Token\n', ' * Generic implementation for the required functionality of the ERC721 standard\n', ' */\n', 'contract ERC721Token is ERC721 {\n', '  using SafeMath for uint256;\n', '\n', '  // Total amount of tokens\n', '  uint256 private totalTokens;\n', '\n', '  // Mapping from token ID to owner\n', '  mapping (uint256 => address) private tokenOwner;\n', '\n', '  // Mapping from token ID to approved address\n', '  mapping (uint256 => address) private tokenApprovals;\n', '\n', '  // Mapping from owner to list of owned token IDs\n', '  mapping (address => uint256[]) private ownedTokens;\n', '\n', '  // Mapping from token ID to index of the owner tokens list\n', '  mapping(uint256 => uint256) private ownedTokensIndex;\n', '\n', '  /**\n', '  * @dev Guarantees msg.sender is owner of the given token\n', '  * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender\n', '  */\n', '  modifier onlyOwnerOf(uint256 _tokenId) {\n', '    require(ownerOf(_tokenId) == msg.sender);\n', '    _;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the total amount of tokens stored by the contract\n', '  * @return uint256 representing the total amount of tokens\n', '  */\n', '  function totalSupply() public view returns (uint256) {\n', '    return totalTokens;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the balance of the specified address\n', '  * @param _owner address to query the balance of\n', '  * @return uint256 representing the amount owned by the passed address\n', '  */\n', '  function balanceOf(address _owner) public view returns (uint256) {\n', '    return ownedTokens[_owner].length;\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the list of tokens owned by a given address\n', '  * @param _owner address to query the tokens of\n', '  * @return uint256[] representing the list of tokens owned by the passed address\n', '  */\n', '  function tokensOf(address _owner) public view returns (uint256[]) {\n', '    return ownedTokens[_owner];\n', '  }\n', '\n', '  /**\n', '  * @dev Gets the owner of the specified token ID\n', '  * @param _tokenId uint256 ID of the token to query the owner of\n', '  * @return owner address currently marked as the owner of the given token ID\n', '  */\n', '  function ownerOf(uint256 _tokenId) public view returns (address) {\n', '    address owner = tokenOwner[_tokenId];\n', '    require(owner != address(0));\n', '    return owner;\n', '  }\n', '\n', '  /**\n', '   * @dev Gets the approved address to take ownership of a given token ID\n', '   * @param _tokenId uint256 ID of the token to query the approval of\n', '   * @return address currently approved to take ownership of the given token ID\n', '   */\n', '  function approvedFor(uint256 _tokenId) public view returns (address) {\n', '    return tokenApprovals[_tokenId];\n', '  }\n', '\n', '  /**\n', '  * @dev Transfers the ownership of a given token ID to another address\n', '  * @param _to address to receive the ownership of the given token ID\n', '  * @param _tokenId uint256 ID of the token to be transferred\n', '  */\n', '  function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {\n', '    clearApprovalAndTransfer(msg.sender, _to, _tokenId);\n', '  }\n', '\n', '  /**\n', '  * @dev Approves another address to claim for the ownership of the given token ID\n', '  * @param _to address to be approved for the given token ID\n', '  * @param _tokenId uint256 ID of the token to be approved\n', '  */\n', '  function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {\n', '    address owner = ownerOf(_tokenId);\n', '    require(_to != owner);\n', '    if (approvedFor(_tokenId) != 0 || _to != 0) {\n', '      tokenApprovals[_tokenId] = _to;\n', '      emit Approval(owner, _to, _tokenId);\n', '    }\n', '  }\n', '\n', '  /**\n', '  * @dev Claims the ownership of a given token ID\n', '  * @param _tokenId uint256 ID of the token being claimed by the msg.sender\n', '  */\n', '  function takeOwnership(uint256 _tokenId) public {\n', '    require(isApprovedFor(msg.sender, _tokenId));\n', '    clearApprovalAndTransfer(ownerOf(_tokenId), msg.sender, _tokenId);\n', '  }\n', '\n', '  /**\n', '  * @dev Mint token function\n', '  * @param _to The address that will own the minted token\n', '  * @param _tokenId uint256 ID of the token to be minted by the msg.sender\n', '  */\n', '  function _mint(address _to, uint256 _tokenId) internal {\n', '    require(_to != address(0));\n', '    addToken(_to, _tokenId);\n', '    emit Transfer(0x0, _to, _tokenId);\n', '  }\n', '\n', '  /**\n', '  * @dev Burns a specific token\n', '  * @param _tokenId uint256 ID of the token being burned by the msg.sender\n', '  */\n', '  function _burn(uint256 _tokenId) onlyOwnerOf(_tokenId) internal {\n', '    if (approvedFor(_tokenId) != 0) {\n', '      clearApproval(msg.sender, _tokenId);\n', '    }\n', '    removeToken(msg.sender, _tokenId);\n', '    emit Transfer(msg.sender, 0x0, _tokenId);\n', '  }\n', '\n', '  /**\n', '   * @dev Tells whether the msg.sender is approved for the given token ID or not\n', '   * This function is not private so it can be extended in further implementations like the operatable ERC721\n', '   * @param _owner address of the owner to query the approval of\n', '   * @param _tokenId uint256 ID of the token to query the approval of\n', '   * @return bool whether the msg.sender is approved for the given token ID or not\n', '   */\n', '  function isApprovedFor(address _owner, uint256 _tokenId) internal view returns (bool) {\n', '    return approvedFor(_tokenId) == _owner;\n', '  }\n', '\n', '  /**\n', '  * @dev Internal function to clear current approval and transfer the ownership of a given token ID\n', '  * @param _from address which you want to send tokens from\n', '  * @param _to address which you want to transfer the token to\n', '  * @param _tokenId uint256 ID of the token to be transferred\n', '  */\n', '  function clearApprovalAndTransfer(address _from, address _to, uint256 _tokenId) internal {\n', '    require(_to != address(0));\n', '    require(_to != ownerOf(_tokenId));\n', '    require(ownerOf(_tokenId) == _from);\n', '\n', '    clearApproval(_from, _tokenId);\n', '    removeToken(_from, _tokenId);\n', '    addToken(_to, _tokenId);\n', '    emit Transfer(_from, _to, _tokenId);\n', '  }\n', '\n', '  /**\n', '  * @dev Internal function to clear current approval of a given token ID\n', '  * @param _tokenId uint256 ID of the token to be transferred\n', '  */\n', '  function clearApproval(address _owner, uint256 _tokenId) private {\n', '    require(ownerOf(_tokenId) == _owner);\n', '    tokenApprovals[_tokenId] = 0;\n', '    emit Approval(_owner, 0, _tokenId);\n', '  }\n', '\n', '  /**\n', '  * @dev Internal function to add a token ID to the list of a given address\n', '  * @param _to address representing the new owner of the given token ID\n', '  * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address\n', '  */\n', '  function addToken(address _to, uint256 _tokenId) private {\n', '    require(tokenOwner[_tokenId] == address(0));\n', '    tokenOwner[_tokenId] = _to;\n', '    uint256 length = balanceOf(_to);\n', '    ownedTokens[_to].push(_tokenId);\n', '    ownedTokensIndex[_tokenId] = length;\n', '    totalTokens = totalTokens.add(1);\n', '  }\n', '\n', '  /**\n', '  * @dev Internal function to remove a token ID from the list of a given address\n', '  * @param _from address representing the previous owner of the given token ID\n', '  * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address\n', '  */\n', '  function removeToken(address _from, uint256 _tokenId) private {\n', '    require(ownerOf(_tokenId) == _from);\n', '\n', '    uint256 tokenIndex = ownedTokensIndex[_tokenId];\n', '    uint256 lastTokenIndex = balanceOf(_from).sub(1);\n', '    uint256 lastToken = ownedTokens[_from][lastTokenIndex];\n', '\n', '    tokenOwner[_tokenId] = 0;\n', '    ownedTokens[_from][tokenIndex] = lastToken;\n', '    ownedTokens[_from][lastTokenIndex] = 0;\n', '    // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to\n', '    // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping\n', '    // the lastToken to the first position, and then dropping the element placed in the last position of the list\n', '\n', '    ownedTokens[_from].length--;\n', '    ownedTokensIndex[_tokenId] = 0;\n', '    ownedTokensIndex[lastToken] = tokenIndex;\n', '    totalTokens = totalTokens.sub(1);\n', '  }\n', '}\n', '\n', '// File: contracts/EtherSpaceCore.sol\n', '\n', 'contract EtherSpaceCore is ERC721Token, Ownable, Claimable, Destructible {\n', '\n', '  string public url = "https://etherspace.co/";\n', '\n', '  using SafeMath for uint256;\n', '\n', '  struct Spaceship {\n', '    uint16 model;\n', '    bool battleMode;\n', '    uint32 battleWins;\n', '    uint32 battleLosses;\n', '    uint256 battleStake;\n', '    bytes5 upgrades;\n', '    bool isAuction;\n', '    uint256 auctionPrice;\n', '  }\n', '\n', '  mapping (uint256 => Spaceship) private spaceships;\n', '  uint256[] private spaceshipIds;\n', '\n', '  /* */\n', '  struct SpaceshipProduct {\n', '    uint16 class;\n', '    bytes8 attributes;\n', '    uint256 price; // initial price\n', '    uint32 totalSold; // The quantity of spaceships sold for this model\n', '  }\n', '\n', '  mapping (uint16 => SpaceshipProduct) private spaceshipProducts;\n', '  uint16 spaceshipProductCount = 0; // The next count for spaceships products created\n', '\n', '  mapping (address => uint256) private balances; // User balances\n', '\n', '  // Battle\n', '  uint256 public battleFee = 0;\n', '\n', '  // Marketplace\n', '  uint32 public saleFee = 5; // 5%\n', '\n', '  EtherSpaceUpgradeInterface public upgradeContract;\n', '  EtherSpaceBattleInterface public battleContract;\n', '\n', '  /* Events */\n', '  event EventCashOut (\n', '    address indexed player,\n', '    uint256 amount\n', '  );\n', '  event EventBattleAdd (\n', '    address indexed player,\n', '    uint256 tokenId\n', '  );\n', '  event EventBattleRemove (\n', '    address indexed player,\n', '    uint256 tokenId\n', '  );\n', '  event EventBattle (\n', '    address indexed player,\n', '    uint256 tokenId,\n', '    uint256 tokenIdToAttack,\n', '    uint256 tokenIdWinner\n', '  );\n', '  event EventBuySpaceshipUpgrade (\n', '    address indexed player,\n', '    uint256 tokenId,\n', '    uint16 model,\n', '    uint8 position\n', '  );\n', '  event Log (\n', '    string message\n', '  );\n', '\n', '  constructor() public {\n', '    _newSpaceshipProduct(0,   0x001e,   0x0514,   0x0004,   0x0005,   50000000000000000); // price 0.05\n', '    _newSpaceshipProduct(0,   0x001d,   0x0226,   0x0005,   0x0006,   60000000000000000); // price 0.06\n', '    _newSpaceshipProduct(0,   0x001f,   0x03e8,   0x0003,   0x0009,   70000000000000000); // price 0.07\n', '    _newSpaceshipProduct(0,   0x001e,   0x0258,   0x0005,   0x0009,   80000000000000000); // price 0.08\n', '    _newSpaceshipProduct(0,   0x001a,   0x0064,   0x0006,   0x000a,   90000000000000000); // price 0.09\n', '    _newSpaceshipProduct(0,   0x0015,   0x0032,   0x0007,   0x000b,  100000000000000000); // price 0.10\n', '  }\n', '\n', '  function _setUpgradeContract(address _address) private {\n', '    EtherSpaceUpgradeInterface candidateContract = EtherSpaceUpgradeInterface(_address);\n', '\n', '    require(candidateContract.isEtherSpaceUpgrade());\n', '\n', '    // Set the new contract address\n', '    upgradeContract = candidateContract;\n', '  }\n', '\n', '  function _setBattleContract(address _address) private {\n', '    EtherSpaceBattleInterface candidateContract = EtherSpaceBattleInterface(_address);\n', '\n', '    require(candidateContract.isEtherSpaceBattle());\n', '\n', '    // Set the new contract address\n', '    battleContract = candidateContract;\n', '  }\n', '\n', '  /* Constructor rejects payments to avoid mistakes */\n', '  function() external payable {\n', '      require(false);\n', '  }\n', '\n', '  /* ERC721Metadata */\n', '  function name() external pure returns (string) {\n', '    return "EtherSpace";\n', '  }\n', '\n', '  function symbol() external pure returns (string) {\n', '    return "ESPC";\n', '  }\n', '\n', '  /* Enable listing of all deeds (alternative to ERC721Enumerable to avoid having to work with arrays). */\n', '  function ids() external view returns (uint256[]) {\n', '    return spaceshipIds;\n', '  }\n', '\n', '  /* Owner functions */\n', '  function setSpaceshipPrice(uint16 _model, uint256 _price) external onlyOwner {\n', '    require(_price > 0);\n', '\n', '    spaceshipProducts[_model].price = _price;\n', '  }\n', '\n', '  function newSpaceshipProduct(uint16 _class, bytes2 _propulsion, bytes2 _weight, bytes2 _attack, bytes2 _armour, uint256 _price) external onlyOwner {\n', '    _newSpaceshipProduct(_class, _propulsion, _weight, _attack, _armour, _price);\n', '  }\n', '\n', '  function setBattleFee(uint256 _fee) external onlyOwner {\n', '    battleFee = _fee;\n', '  }\n', '\n', '  function setUpgradeContract(address _address) external onlyOwner {\n', '    _setUpgradeContract(_address);\n', '  }\n', '\n', '  function setBattleContract(address _address) external onlyOwner {\n', '    _setBattleContract(_address);\n', '  }\n', '\n', '  function giftSpaceship(uint16 _model, address _player) external onlyOwner {\n', '    _generateSpaceship(_model, _player);\n', '  }\n', '\n', '  function newSpaceshipUpgrade(bytes1 _identifier, uint8 _position, uint256 _price) external onlyOwner {\n', '    upgradeContract.newSpaceshipUpgrade(_identifier, _position, _price);\n', '  }\n', '\n', '  /* Spaceship Product functions */\n', '  function _newSpaceshipProduct(uint16 _class, bytes2 _propulsion, bytes2 _weight, bytes2 _attack, bytes2 _armour, uint256 _price) private {\n', '    bytes memory attributes = new bytes(8);\n', '    attributes[0] = _propulsion[0];\n', '    attributes[1] = _propulsion[1];\n', '    attributes[2] = _weight[0];\n', '    attributes[3] = _weight[1];\n', '    attributes[4] = _attack[0];\n', '    attributes[5] = _attack[1];\n', '    attributes[6] = _armour[0];\n', '    attributes[7] = _armour[1];\n', '\n', '    spaceshipProducts[spaceshipProductCount++] = SpaceshipProduct(_class, ByteConvert.bytesToBytes8(attributes), _price, 0);\n', '  }\n', '\n', '  /* CashOut */\n', '  function cashOut() public {\n', '    require(address(this).balance >= balances[msg.sender]); // Checking if this contract has enought money to pay\n', '    require(balances[msg.sender] > 0); // Cannot cashOut zero amount\n', '\n', '    uint256 _balance = balances[msg.sender];\n', '\n', '    balances[msg.sender] = 0;\n', '    msg.sender.transfer(_balance);\n', '\n', '    emit EventCashOut(msg.sender, _balance);\n', '  }\n', '\n', '  /* Marketplace functions */\n', '  function buySpaceship(uint16 _model) public payable {\n', '    require(msg.value > 0);\n', '    require(msg.value == spaceshipProducts[_model].price);\n', '    require(spaceshipProducts[_model].price > 0);\n', '\n', '    _generateSpaceship(_model, msg.sender);\n', '\n', '    balances[owner] += spaceshipProducts[_model].price;\n', '  }\n', '\n', '  function _generateSpaceship(uint16 _model, address _player) private {\n', '    // Build a new spaceship for player\n', '    uint256 tokenId = spaceshipIds.length;\n', '    spaceshipIds.push(tokenId);\n', '    super._mint(_player, tokenId);\n', '\n', '    spaceships[tokenId] = Spaceship({\n', '      model: _model,\n', '      battleMode: false,\n', '      battleWins: 0,\n', '      battleLosses: 0,\n', '      battleStake: 0,\n', '      upgrades: "\\x00\\x00\\x00\\x00\\x00", // Prepared to have 5 different types of upgrades\n', '      isAuction: false,\n', '      auctionPrice: 0\n', '    });\n', '\n', '    spaceshipProducts[_model].totalSold++;\n', '  }\n', '\n', '  function sellSpaceship(uint256 _tokenId, uint256 _price) public onlyOwnerOf(_tokenId) {\n', '    spaceships[_tokenId].isAuction = true;\n', '    spaceships[_tokenId].auctionPrice = _price;\n', '  }\n', '\n', '  function bidSpaceship(uint256 _tokenId) public payable {\n', '    require(getPlayerSpaceshipAuctionById(_tokenId)); // must be for sale\n', '    require(getPlayerSpaceshipAuctionPriceById(_tokenId) == msg.value); // value must be exactly\n', '\n', '    // Giving the sold percentage fee to contract owner\n', '    uint256 ownerPercentage = msg.value.mul(uint256(saleFee)).div(100);\n', '    balances[owner] += ownerPercentage;\n', '\n', '    // Giving the sold amount minus owner fee to seller\n', '    balances[getPlayerSpaceshipOwnerById(_tokenId)] += msg.value.sub(ownerPercentage);\n', '\n', '    // Transfering spaceship to buyer\n', '    super.clearApprovalAndTransfer(getPlayerSpaceshipOwnerById(_tokenId), msg.sender, _tokenId);\n', '\n', '    // Removing from auction\n', '    spaceships[_tokenId].isAuction = false;\n', '    spaceships[_tokenId].auctionPrice = 0;\n', '  }\n', '\n', '  /* Battle functions */\n', '  function battleAdd(uint256 _tokenId) public payable onlyOwnerOf(_tokenId) {\n', '    require(msg.value == getPlayerSpaceshipBattleStakeById(_tokenId));\n', '    require(msg.value > 0);\n', '    require(spaceships[_tokenId].battleMode == false);\n', '\n', '    spaceships[_tokenId].battleMode = true;\n', '    spaceships[_tokenId].battleStake = msg.value;\n', '\n', '    emit EventBattleAdd(msg.sender, _tokenId);\n', '  }\n', '\n', '  function battleRemove(uint256 _tokenId) public onlyOwnerOf(_tokenId) {\n', '    require(spaceships[_tokenId].battleMode == true);\n', '\n', '    spaceships[_tokenId].battleMode = false;\n', '\n', '    balances[msg.sender] = balances[msg.sender].add(spaceships[_tokenId].battleStake);\n', '\n', '    emit EventBattleRemove(msg.sender, _tokenId);\n', '  }\n', '\n', '  function battle(uint256 _tokenId, uint256 _tokenIdToAttack) public payable onlyOwnerOf(_tokenId) {\n', '    require (spaceships[_tokenIdToAttack].battleMode == true); // ship to attack must be in battle mode\n', '    require (spaceships[_tokenId].battleMode == false); // attacking ship must not be offered for battle\n', '    require(msg.value == getPlayerSpaceshipBattleStakeById(_tokenId));\n', '\n', '    uint256 battleStakeDefender = spaceships[_tokenIdToAttack].battleStake;\n', '\n', '    bool result = battleContract.battle(spaceshipProducts[spaceships[_tokenId].model].attributes, spaceships[_tokenId].upgrades, spaceshipProducts[spaceships[_tokenIdToAttack].model].attributes, spaceships[_tokenIdToAttack].upgrades);\n', '\n', '    if (result) {\n', '        spaceships[_tokenId].battleWins++;\n', '        spaceships[_tokenIdToAttack].battleLosses++;\n', '\n', '        balances[super.ownerOf(_tokenId)] += (battleStakeDefender + msg.value) - battleFee;\n', '        spaceships[_tokenIdToAttack].battleStake = 0;\n', '\n', '        emit EventBattle(msg.sender, _tokenId, _tokenIdToAttack, _tokenId);\n', '\n', '    } else {\n', '        spaceships[_tokenId].battleLosses++;\n', '        spaceships[_tokenIdToAttack].battleWins++;\n', '\n', '        balances[super.ownerOf(_tokenIdToAttack)] += (battleStakeDefender + msg.value) - battleFee;\n', '        spaceships[_tokenIdToAttack].battleStake = 0;\n', '\n', '        emit EventBattle(msg.sender, _tokenId, _tokenIdToAttack, _tokenIdToAttack);\n', '    }\n', '\n', '    balances[owner] += battleFee;\n', '\n', '    spaceships[_tokenIdToAttack].battleMode = false;\n', '  }\n', '\n', '  /* Upgrade functions */\n', '  function buySpaceshipUpgrade(uint256 _tokenId, uint16 _model, uint8 _position) public payable onlyOwnerOf(_tokenId) {\n', '    require(msg.value > 0);\n', '    uint256 upgradePrice = upgradeContract.getSpaceshipUpgradePriceByModel(_model, _position);\n', '    require(msg.value == upgradePrice);\n', '    require(getPlayerSpaceshipBattleModeById(_tokenId) == false);\n', '\n', '    bytes5 currentUpgrades = spaceships[_tokenId].upgrades;\n', '    upgradeContract.isSpaceshipUpgradeAllowed(currentUpgrades, _model, _position);\n', '\n', '    spaceships[_tokenId].upgrades = upgradeContract.buySpaceshipUpgrade(currentUpgrades, _model, _position);\n', '\n', '    balances[owner] += upgradePrice;\n', '\n', '    emit EventBuySpaceshipUpgrade(msg.sender, _tokenId, _model, _position);\n', '  }\n', '\n', '  /* Getters getPlayer* */\n', '  function getPlayerSpaceshipCount(address _player) public view returns (uint256) {\n', '    return super.balanceOf(_player);\n', '  }\n', '\n', '  function getPlayerSpaceshipModelById(uint256 _tokenId) public view returns (uint16) {\n', '    return spaceships[_tokenId].model;\n', '  }\n', '\n', '  function getPlayerSpaceshipOwnerById(uint256 _tokenId) public view returns (address) {\n', '    return super.ownerOf(_tokenId);\n', '  }\n', '\n', '  function getPlayerSpaceshipModelByIndex(address _owner, uint256 _index) public view returns (uint16) {\n', '    return spaceships[super.tokensOf(_owner)[_index]].model;\n', '  }\n', '\n', '  function getPlayerSpaceshipAuctionById(uint256 _tokenId) public view returns (bool) {\n', '    return spaceships[_tokenId].isAuction;\n', '  }\n', '\n', '  function getPlayerSpaceshipAuctionPriceById(uint256 _tokenId) public view returns (uint256) {\n', '    return spaceships[_tokenId].auctionPrice;\n', '  }\n', '\n', '  function getPlayerSpaceshipBattleModeById(uint256 _tokenId) public view returns (bool) {\n', '    return spaceships[_tokenId].battleMode;\n', '  }\n', '\n', '  function getPlayerSpaceshipBattleStakePaidById(uint256 _tokenId) public view returns (uint256) {\n', '    return spaceships[_tokenId].battleStake;\n', '  }\n', '\n', '  function getPlayerSpaceshipBattleStakeById(uint256 _tokenId) public view returns (uint256) {\n', '    return battleContract.calculateStake(spaceshipProducts[spaceships[_tokenId].model].attributes, spaceships[_tokenId].upgrades);\n', '  }\n', '\n', '  function getPlayerSpaceshipBattleLevelById(uint256 _tokenId) public view returns (uint256) {\n', '    return battleContract.calculateLevel(spaceshipProducts[spaceships[_tokenId].model].attributes, spaceships[_tokenId].upgrades);\n', '  }\n', '\n', '  function getPlayerSpaceshipBattleWinsById(uint256 _tokenId) public view returns (uint32) {\n', '    return spaceships[_tokenId].battleWins;\n', '  }\n', '\n', '  function getPlayerSpaceshipBattleLossesById(uint256 _tokenId) public view returns (uint32) {\n', '    return spaceships[_tokenId].battleLosses;\n', '  }\n', '\n', '  function getPlayerSpaceships(address _owner) public view returns (uint256[]) {\n', '    return super.tokensOf(_owner);\n', '  }\n', '\n', '  function getPlayerBalance(address _owner) public view returns (uint256) {\n', '    return balances[_owner];\n', '  }\n', '\n', '  function getPlayerSpaceshipUpgradesById(uint256 _tokenId) public view returns (bytes5) {\n', '    return spaceships[_tokenId].upgrades;\n', '  }\n', '\n', '  /* Getters getSpaceshipProduct* */\n', '  function getSpaceshipProductPriceByModel(uint16 _model) public view returns (uint256) {\n', '    return spaceshipProducts[_model].price;\n', '  }\n', '\n', '  function getSpaceshipProductClassByModel(uint16 _model) public view returns (uint16) {\n', '    return spaceshipProducts[_model].class;\n', '  }\n', '\n', '  function getSpaceshipProductTotalSoldByModel(uint16 _model) public view returns (uint256) {\n', '    return spaceshipProducts[_model].totalSold;\n', '  }\n', '\n', '  function getSpaceshipProductAttributesByModel(uint16 _model) public view returns (bytes8) {\n', '    return spaceshipProducts[_model].attributes;\n', '  }\n', '\n', '  function getSpaceshipProductCount() public view returns (uint16) {\n', '    return spaceshipProductCount;\n', '  }\n', '\n', '  /* Getters getSpaceship* */\n', '  function getSpaceshipTotalSold() public view returns (uint256) {\n', '    return super.totalSupply();\n', '  }\n', '\n', '  /* Getters Spaceship Upgrades */\n', '  function getSpaceshipUpgradePriceByModel(uint16 _model, uint8 _position) public view returns (uint256) {\n', '    return upgradeContract.getSpaceshipUpgradePriceByModel(_model, _position);\n', '  }\n', '\n', '  function getSpaceshipUpgradeTotalSoldByModel(uint16 _model, uint8 _position) public view returns (uint256) {\n', '    return upgradeContract.getSpaceshipUpgradeTotalSoldByModel(_model, _position);\n', '  }\n', '\n', '  function getSpaceshipUpgradeCount() public view returns (uint256) {\n', '    return upgradeContract.getSpaceshipUpgradeCount();\n', '  }\n', '\n', '}']