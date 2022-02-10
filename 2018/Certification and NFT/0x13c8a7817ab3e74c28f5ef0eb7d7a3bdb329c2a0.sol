['pragma solidity ^0.4.19;\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '  address public ceoWallet;\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '  constructor() public {\n', '    owner = msg.sender;\n', '    ceoWallet = msg.sender;\n', '  }\n', '\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '}\n', '\n', '// Interface for contracts conforming to ERC-721: Non-Fungible Tokens\n', 'contract ERC721 {\n', '  event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);\n', '  event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);\n', '\n', '  function balanceOf(address _owner) public view returns (uint256 _balance);\n', '  function ownerOf(uint256 _tokenId) public view returns (address _owner);\n', '  function transfer(address _to, uint256 _tokenId) public;\n', '  function approve(address _to, uint256 _tokenId) public;\n', '  function takeOwnership(uint256 _tokenId) public;\n', '  function totalSupply() public view returns (uint256 total);\n', '}\n', '\n', '\n', 'contract CryptoRomeControl is Ownable {\n', '\n', '    bool public paused = false;\n', '\n', '    modifier whenNotPaused() {\n', '        require(!paused);\n', '        _;\n', '    }\n', '\n', '    modifier whenPaused {\n', '        require(paused);\n', '        _;\n', '    }\n', '    \n', '    function transferWalletOwnership(address newWalletAddress) onlyOwner public {\n', '      require(newWalletAddress != address(0));\n', '      ceoWallet = newWalletAddress;\n', '    }\n', '\n', '    function pause() external onlyOwner whenNotPaused {\n', '        paused = true;\n', '    }\n', '\n', '    function unpause() public onlyOwner whenPaused {\n', '        paused = false;\n', '    }\n', '}\n', '\n', 'contract CryptoRomeAuction is CryptoRomeControl {\n', '\n', '    address public WonderOwnershipAdd;\n', '    uint256 public auctionStart;\n', '    uint256 public startingBid;\n', '    uint256 public auctionDuration;\n', '    address public highestBidder;\n', '    uint256 public highestBid;\n', '    address public paymentAddress;\n', '    uint256 public wonderId;\n', '    bool public ended;\n', '\n', '    event Bid(address from, uint256 amount);\n', '    event AuctionEnded(address winner, uint256 amount);\n', '\n', '    constructor(uint256 _startTime, uint256 _startingBid, uint256 _duration, address wallet, uint256 _wonderId, address developer) public {\n', '        WonderOwnershipAdd = msg.sender;\n', '        auctionStart = _startTime;\n', '        startingBid = _startingBid;\n', '        auctionDuration = _duration;\n', '        paymentAddress = wallet;\n', '        wonderId = _wonderId;\n', '        transferOwnership(developer);\n', '    }\n', '    \n', '    function getAuctionData() public view returns(uint256, uint256, uint256, address) {\n', '        return(auctionStart, auctionDuration, highestBid, highestBidder);\n', '    }\n', '\n', '    function _isContract(address _user) internal view returns (bool) {\n', '        uint size;\n', '        assembly { size := extcodesize(_user) }\n', '        return size > 0;\n', '    }\n', '\n', '    function auctionExpired() public view returns (bool) {\n', '        return now > (SafeMath.add(auctionStart, auctionDuration));\n', '    }\n', '\n', '    function bidOnWonder() public payable {\n', '        require(!_isContract(msg.sender));\n', '        require(!auctionExpired());\n', '        require(msg.value >= (highestBid + 10000000000000000));\n', '\n', '        if (highestBid != 0) {\n', '            highestBidder.transfer(highestBid);\n', '        }\n', '\n', '        highestBidder = msg.sender;\n', '        highestBid = msg.value;\n', '\n', '        emit Bid(msg.sender, msg.value);\n', '    }\n', '\n', '    function endAuction() public onlyOwner {\n', '        require(auctionExpired());\n', '        require(!ended);\n', '        ended = true;\n', '        emit AuctionEnded(highestBidder, highestBid);\n', '        // Transfer the item to the buyer\n', '        Wonder(WonderOwnershipAdd).transfer(highestBidder, wonderId);\n', '\n', '        paymentAddress.transfer(address(this).balance);\n', '    }\n', '}\n', '\n', 'contract Wonder is ERC721, CryptoRomeControl {\n', '    \n', '    // Name and symbol of the non fungible token, as defined in ERC721.\n', '    string public constant name = "CryptoRomeWonder";\n', '    string public constant symbol = "CROMEW";\n', '\n', '    uint256[] internal allWonderTokens;\n', '\n', '    mapping(uint256 => string) internal tokenURIs;\n', '    address public originalAuction;\n', '    mapping (uint256 => bool) public wonderForSale;\n', '    mapping (uint256 => uint256) public askingPrice;\n', '\n', '    // Map of Wonder to the owner\n', '    mapping (uint256 => address) public wonderIndexToOwner;\n', '    mapping (address => uint256) ownershipTokenCount;\n', '    mapping (uint256 => address) wonderIndexToApproved;\n', '    \n', '    modifier onlyOwnerOf(uint256 _tokenId) {\n', '        require(wonderIndexToOwner[_tokenId] == msg.sender);\n', '        _;\n', '    }\n', '\n', '    function updateTokenUri(uint256 _tokenId, string _tokenURI) public whenNotPaused onlyOwner {\n', '        _setTokenURI(_tokenId, _tokenURI);\n', '    }\n', '\n', '    function startWonderAuction(string _tokenURI, address wallet) public whenNotPaused onlyOwner {\n', '        uint256 finalId = _createWonder(msg.sender);\n', '        _setTokenURI(finalId, _tokenURI);\n', '        //Starting auction\n', '        originalAuction = new CryptoRomeAuction(now, 10 finney, 1 weeks, wallet, finalId, msg.sender);\n', '        _transfer(msg.sender, originalAuction, finalId);\n', '    }\n', '    \n', '    function createWonderNotAuction(string _tokenURI) public whenNotPaused onlyOwner returns (uint256) {\n', '        uint256 finalId = _createWonder(msg.sender);\n', '        _setTokenURI(finalId, _tokenURI);\n', '        return finalId;\n', '    }\n', '    \n', '    function sellWonder(uint256 _wonderId, uint256 _askingPrice) onlyOwnerOf(_wonderId) whenNotPaused public {\n', '        wonderForSale[_wonderId] = true;\n', '        askingPrice[_wonderId] = _askingPrice;\n', '    }\n', '    \n', '    function cancelWonderSale(uint256 _wonderId) onlyOwnerOf(_wonderId) whenNotPaused public {\n', '        wonderForSale[_wonderId] = false;\n', '        askingPrice[_wonderId] = 0;\n', '    }\n', '    \n', '    function purchaseWonder(uint256 _wonderId) whenNotPaused public payable {\n', '        require(wonderForSale[_wonderId]);\n', '        require(msg.value >= askingPrice[_wonderId]);\n', '        wonderForSale[_wonderId] = false;\n', '        uint256 fee = devFee(msg.value);\n', '        ceoWallet.transfer(fee);\n', '        wonderIndexToOwner[_wonderId].transfer(SafeMath.sub(address(this).balance, fee));\n', '        _transfer(wonderIndexToOwner[_wonderId], msg.sender, _wonderId);\n', '    }\n', '    \n', '    function _transfer(address _from, address _to, uint256 _tokenId) internal {\n', '        ownershipTokenCount[_to] = SafeMath.add(ownershipTokenCount[_to], 1);\n', '        wonderIndexToOwner[_tokenId] = _to;\n', '        if (_from != address(0)) {\n', '            // clear any previously approved ownership exchange\n', '            ownershipTokenCount[_from] = SafeMath.sub(ownershipTokenCount[_from], 1);\n', '            delete wonderIndexToApproved[_tokenId];\n', '        }\n', '    }\n', '\n', '    function _createWonder(address _owner) internal returns (uint) {\n', '        uint256 newWonderId = allWonderTokens.push(allWonderTokens.length) - 1;\n', '        wonderForSale[newWonderId] = false;\n', '\n', '        // Only 8 wonders should ever exist (0-7)\n', '        require(newWonderId < 8);\n', '        _transfer(0, _owner, newWonderId);\n', '        return newWonderId;\n', '    }\n', '    \n', '    function devFee(uint256 amount) internal pure returns(uint256){\n', '        return SafeMath.div(SafeMath.mul(amount, 3), 100);\n', '    }\n', '    \n', '    // Functions for ERC721 Below:\n', '\n', '    // Check is address has approval to transfer wonder.\n', '    function _approvedFor(address _claimant, uint256 _tokenId) internal view returns (bool) {\n', '        return wonderIndexToApproved[_tokenId] == _claimant;\n', '    }\n', '\n', '    function exists(uint256 _tokenId) public view returns (bool) {\n', '        address owner = wonderIndexToOwner[_tokenId];\n', '        return owner != address(0);\n', '    }\n', '\n', '    function tokenURI(uint256 _tokenId) public view returns (string) {\n', '        require(exists(_tokenId));\n', '        return tokenURIs[_tokenId];\n', '    }\n', '\n', '    function _setTokenURI(uint256 _tokenId, string _uri) internal {\n', '        require(exists(_tokenId));\n', '        tokenURIs[_tokenId] = _uri;\n', '    }\n', '\n', '    // Sets a wonder as approved for transfer to another address.\n', '    function _approve(uint256 _tokenId, address _approved) internal {\n', '        wonderIndexToApproved[_tokenId] = _approved;\n', '    }\n', '\n', '    // Returns the number of Wonders owned by a specific address.\n', '    function balanceOf(address _owner) public view returns (uint256 count) {\n', '        return ownershipTokenCount[_owner];\n', '    }\n', '\n', '    // Transfers a Wonder to another address. If transferring to a smart\n', '    // contract ensure that it is aware of ERC-721.\n', '    function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) whenNotPaused {\n', '        require(_to != address(0));\n', '        require(_to != address(this));\n', '\n', '        _transfer(msg.sender, _to, _tokenId);\n', '        emit Transfer(msg.sender, _to, _tokenId);\n', '    }\n', '\n', '    //  Permit another address the right to transfer a specific Wonder via\n', '    //  transferFrom(). \n', '    function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) whenNotPaused {\n', '        _approve(_tokenId, _to);\n', '\n', '        emit Approval(msg.sender, _to, _tokenId);\n', '    }\n', '\n', '    // Transfer a Wonder owned by another address, for which the calling address\n', '    // has previously been granted transfer approval by the owner.\n', '    function takeOwnership(uint256 _tokenId) public {\n', '\n', '    require(wonderIndexToApproved[_tokenId] == msg.sender);\n', '    address owner = ownerOf(_tokenId);\n', '    _transfer(owner, msg.sender, _tokenId);\n', '    emit Transfer(owner, msg.sender, _tokenId);\n', '\n', '  }\n', '\n', '    // Eight Wonders will ever exist\n', '    function totalSupply() public view returns (uint) {\n', '        return 8;\n', '    }\n', '\n', '    function ownerOf(uint256 _tokenId) public view returns (address owner)\n', '    {\n', '        owner = wonderIndexToOwner[_tokenId];\n', '        require(owner != address(0));\n', '    }\n', '\n', '    // List of all Wonder IDs assigned to an address.\n', '    function tokensOfOwner(address _owner) external view returns(uint256[] ownerTokens) {\n', '        uint256 tokenCount = balanceOf(_owner);\n', '\n', '        if (tokenCount == 0) {\n', '            return new uint256[](0);\n', '        } else {\n', '            uint256[] memory result = new uint256[](tokenCount);\n', '            uint256 totalWonders = totalSupply();\n', '            uint256 resultIndex = 0;\n', '            uint256 wonderId;\n', '\n', '            for (wonderId = 0; wonderId < totalWonders; wonderId++) {\n', '                if (wonderIndexToOwner[wonderId] == _owner) {\n', '                    result[resultIndex] = wonderId;\n', '                    resultIndex++;\n', '                }\n', '            }\n', '            return result;\n', '        }\n', '    }\n', '}\n', '\n', 'library SafeMath {\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}']
['pragma solidity ^0.4.19;\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '  address public ceoWallet;\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '  constructor() public {\n', '    owner = msg.sender;\n', '    ceoWallet = msg.sender;\n', '  }\n', '\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '}\n', '\n', '// Interface for contracts conforming to ERC-721: Non-Fungible Tokens\n', 'contract ERC721 {\n', '  event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);\n', '  event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);\n', '\n', '  function balanceOf(address _owner) public view returns (uint256 _balance);\n', '  function ownerOf(uint256 _tokenId) public view returns (address _owner);\n', '  function transfer(address _to, uint256 _tokenId) public;\n', '  function approve(address _to, uint256 _tokenId) public;\n', '  function takeOwnership(uint256 _tokenId) public;\n', '  function totalSupply() public view returns (uint256 total);\n', '}\n', '\n', '\n', 'contract CryptoRomeControl is Ownable {\n', '\n', '    bool public paused = false;\n', '\n', '    modifier whenNotPaused() {\n', '        require(!paused);\n', '        _;\n', '    }\n', '\n', '    modifier whenPaused {\n', '        require(paused);\n', '        _;\n', '    }\n', '    \n', '    function transferWalletOwnership(address newWalletAddress) onlyOwner public {\n', '      require(newWalletAddress != address(0));\n', '      ceoWallet = newWalletAddress;\n', '    }\n', '\n', '    function pause() external onlyOwner whenNotPaused {\n', '        paused = true;\n', '    }\n', '\n', '    function unpause() public onlyOwner whenPaused {\n', '        paused = false;\n', '    }\n', '}\n', '\n', 'contract CryptoRomeAuction is CryptoRomeControl {\n', '\n', '    address public WonderOwnershipAdd;\n', '    uint256 public auctionStart;\n', '    uint256 public startingBid;\n', '    uint256 public auctionDuration;\n', '    address public highestBidder;\n', '    uint256 public highestBid;\n', '    address public paymentAddress;\n', '    uint256 public wonderId;\n', '    bool public ended;\n', '\n', '    event Bid(address from, uint256 amount);\n', '    event AuctionEnded(address winner, uint256 amount);\n', '\n', '    constructor(uint256 _startTime, uint256 _startingBid, uint256 _duration, address wallet, uint256 _wonderId, address developer) public {\n', '        WonderOwnershipAdd = msg.sender;\n', '        auctionStart = _startTime;\n', '        startingBid = _startingBid;\n', '        auctionDuration = _duration;\n', '        paymentAddress = wallet;\n', '        wonderId = _wonderId;\n', '        transferOwnership(developer);\n', '    }\n', '    \n', '    function getAuctionData() public view returns(uint256, uint256, uint256, address) {\n', '        return(auctionStart, auctionDuration, highestBid, highestBidder);\n', '    }\n', '\n', '    function _isContract(address _user) internal view returns (bool) {\n', '        uint size;\n', '        assembly { size := extcodesize(_user) }\n', '        return size > 0;\n', '    }\n', '\n', '    function auctionExpired() public view returns (bool) {\n', '        return now > (SafeMath.add(auctionStart, auctionDuration));\n', '    }\n', '\n', '    function bidOnWonder() public payable {\n', '        require(!_isContract(msg.sender));\n', '        require(!auctionExpired());\n', '        require(msg.value >= (highestBid + 10000000000000000));\n', '\n', '        if (highestBid != 0) {\n', '            highestBidder.transfer(highestBid);\n', '        }\n', '\n', '        highestBidder = msg.sender;\n', '        highestBid = msg.value;\n', '\n', '        emit Bid(msg.sender, msg.value);\n', '    }\n', '\n', '    function endAuction() public onlyOwner {\n', '        require(auctionExpired());\n', '        require(!ended);\n', '        ended = true;\n', '        emit AuctionEnded(highestBidder, highestBid);\n', '        // Transfer the item to the buyer\n', '        Wonder(WonderOwnershipAdd).transfer(highestBidder, wonderId);\n', '\n', '        paymentAddress.transfer(address(this).balance);\n', '    }\n', '}\n', '\n', 'contract Wonder is ERC721, CryptoRomeControl {\n', '    \n', '    // Name and symbol of the non fungible token, as defined in ERC721.\n', '    string public constant name = "CryptoRomeWonder";\n', '    string public constant symbol = "CROMEW";\n', '\n', '    uint256[] internal allWonderTokens;\n', '\n', '    mapping(uint256 => string) internal tokenURIs;\n', '    address public originalAuction;\n', '    mapping (uint256 => bool) public wonderForSale;\n', '    mapping (uint256 => uint256) public askingPrice;\n', '\n', '    // Map of Wonder to the owner\n', '    mapping (uint256 => address) public wonderIndexToOwner;\n', '    mapping (address => uint256) ownershipTokenCount;\n', '    mapping (uint256 => address) wonderIndexToApproved;\n', '    \n', '    modifier onlyOwnerOf(uint256 _tokenId) {\n', '        require(wonderIndexToOwner[_tokenId] == msg.sender);\n', '        _;\n', '    }\n', '\n', '    function updateTokenUri(uint256 _tokenId, string _tokenURI) public whenNotPaused onlyOwner {\n', '        _setTokenURI(_tokenId, _tokenURI);\n', '    }\n', '\n', '    function startWonderAuction(string _tokenURI, address wallet) public whenNotPaused onlyOwner {\n', '        uint256 finalId = _createWonder(msg.sender);\n', '        _setTokenURI(finalId, _tokenURI);\n', '        //Starting auction\n', '        originalAuction = new CryptoRomeAuction(now, 10 finney, 1 weeks, wallet, finalId, msg.sender);\n', '        _transfer(msg.sender, originalAuction, finalId);\n', '    }\n', '    \n', '    function createWonderNotAuction(string _tokenURI) public whenNotPaused onlyOwner returns (uint256) {\n', '        uint256 finalId = _createWonder(msg.sender);\n', '        _setTokenURI(finalId, _tokenURI);\n', '        return finalId;\n', '    }\n', '    \n', '    function sellWonder(uint256 _wonderId, uint256 _askingPrice) onlyOwnerOf(_wonderId) whenNotPaused public {\n', '        wonderForSale[_wonderId] = true;\n', '        askingPrice[_wonderId] = _askingPrice;\n', '    }\n', '    \n', '    function cancelWonderSale(uint256 _wonderId) onlyOwnerOf(_wonderId) whenNotPaused public {\n', '        wonderForSale[_wonderId] = false;\n', '        askingPrice[_wonderId] = 0;\n', '    }\n', '    \n', '    function purchaseWonder(uint256 _wonderId) whenNotPaused public payable {\n', '        require(wonderForSale[_wonderId]);\n', '        require(msg.value >= askingPrice[_wonderId]);\n', '        wonderForSale[_wonderId] = false;\n', '        uint256 fee = devFee(msg.value);\n', '        ceoWallet.transfer(fee);\n', '        wonderIndexToOwner[_wonderId].transfer(SafeMath.sub(address(this).balance, fee));\n', '        _transfer(wonderIndexToOwner[_wonderId], msg.sender, _wonderId);\n', '    }\n', '    \n', '    function _transfer(address _from, address _to, uint256 _tokenId) internal {\n', '        ownershipTokenCount[_to] = SafeMath.add(ownershipTokenCount[_to], 1);\n', '        wonderIndexToOwner[_tokenId] = _to;\n', '        if (_from != address(0)) {\n', '            // clear any previously approved ownership exchange\n', '            ownershipTokenCount[_from] = SafeMath.sub(ownershipTokenCount[_from], 1);\n', '            delete wonderIndexToApproved[_tokenId];\n', '        }\n', '    }\n', '\n', '    function _createWonder(address _owner) internal returns (uint) {\n', '        uint256 newWonderId = allWonderTokens.push(allWonderTokens.length) - 1;\n', '        wonderForSale[newWonderId] = false;\n', '\n', '        // Only 8 wonders should ever exist (0-7)\n', '        require(newWonderId < 8);\n', '        _transfer(0, _owner, newWonderId);\n', '        return newWonderId;\n', '    }\n', '    \n', '    function devFee(uint256 amount) internal pure returns(uint256){\n', '        return SafeMath.div(SafeMath.mul(amount, 3), 100);\n', '    }\n', '    \n', '    // Functions for ERC721 Below:\n', '\n', '    // Check is address has approval to transfer wonder.\n', '    function _approvedFor(address _claimant, uint256 _tokenId) internal view returns (bool) {\n', '        return wonderIndexToApproved[_tokenId] == _claimant;\n', '    }\n', '\n', '    function exists(uint256 _tokenId) public view returns (bool) {\n', '        address owner = wonderIndexToOwner[_tokenId];\n', '        return owner != address(0);\n', '    }\n', '\n', '    function tokenURI(uint256 _tokenId) public view returns (string) {\n', '        require(exists(_tokenId));\n', '        return tokenURIs[_tokenId];\n', '    }\n', '\n', '    function _setTokenURI(uint256 _tokenId, string _uri) internal {\n', '        require(exists(_tokenId));\n', '        tokenURIs[_tokenId] = _uri;\n', '    }\n', '\n', '    // Sets a wonder as approved for transfer to another address.\n', '    function _approve(uint256 _tokenId, address _approved) internal {\n', '        wonderIndexToApproved[_tokenId] = _approved;\n', '    }\n', '\n', '    // Returns the number of Wonders owned by a specific address.\n', '    function balanceOf(address _owner) public view returns (uint256 count) {\n', '        return ownershipTokenCount[_owner];\n', '    }\n', '\n', '    // Transfers a Wonder to another address. If transferring to a smart\n', '    // contract ensure that it is aware of ERC-721.\n', '    function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) whenNotPaused {\n', '        require(_to != address(0));\n', '        require(_to != address(this));\n', '\n', '        _transfer(msg.sender, _to, _tokenId);\n', '        emit Transfer(msg.sender, _to, _tokenId);\n', '    }\n', '\n', '    //  Permit another address the right to transfer a specific Wonder via\n', '    //  transferFrom(). \n', '    function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) whenNotPaused {\n', '        _approve(_tokenId, _to);\n', '\n', '        emit Approval(msg.sender, _to, _tokenId);\n', '    }\n', '\n', '    // Transfer a Wonder owned by another address, for which the calling address\n', '    // has previously been granted transfer approval by the owner.\n', '    function takeOwnership(uint256 _tokenId) public {\n', '\n', '    require(wonderIndexToApproved[_tokenId] == msg.sender);\n', '    address owner = ownerOf(_tokenId);\n', '    _transfer(owner, msg.sender, _tokenId);\n', '    emit Transfer(owner, msg.sender, _tokenId);\n', '\n', '  }\n', '\n', '    // Eight Wonders will ever exist\n', '    function totalSupply() public view returns (uint) {\n', '        return 8;\n', '    }\n', '\n', '    function ownerOf(uint256 _tokenId) public view returns (address owner)\n', '    {\n', '        owner = wonderIndexToOwner[_tokenId];\n', '        require(owner != address(0));\n', '    }\n', '\n', '    // List of all Wonder IDs assigned to an address.\n', '    function tokensOfOwner(address _owner) external view returns(uint256[] ownerTokens) {\n', '        uint256 tokenCount = balanceOf(_owner);\n', '\n', '        if (tokenCount == 0) {\n', '            return new uint256[](0);\n', '        } else {\n', '            uint256[] memory result = new uint256[](tokenCount);\n', '            uint256 totalWonders = totalSupply();\n', '            uint256 resultIndex = 0;\n', '            uint256 wonderId;\n', '\n', '            for (wonderId = 0; wonderId < totalWonders; wonderId++) {\n', '                if (wonderIndexToOwner[wonderId] == _owner) {\n', '                    result[resultIndex] = wonderId;\n', '                    resultIndex++;\n', '                }\n', '            }\n', '            return result;\n', '        }\n', '    }\n', '}\n', '\n', 'library SafeMath {\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}']
