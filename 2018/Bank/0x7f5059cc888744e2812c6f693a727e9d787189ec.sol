['pragma solidity ^0.4.18;\n', '\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', '    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '/*\n', ' * Ownable\n', ' *\n', ' * Base contract with an owner.\n', ' * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.\n', ' */\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '    function Ownable() {\n', '    owner = msg.sender;\n', '    }\n', '\n', '  modifier onlyOwner() {\n', '    if (msg.sender == owner)\n', '      _;\n', '  }\n', '\n', '  function transferOwnership(address newOwner) onlyOwner {\n', '    if (newOwner != address(0)) owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '// @title Interface for contracts conforming to ERC-721 Non-Fungible Tokens\n', '// @author Dieter Shirley <span class="__cf_email__" data-cfemail="aacecfdecfeacbd2c3c5c7d0cfc484c9c5">[email&#160;protected]</span> (httpsgithub.comdete)\n', 'contract ERC721 {\n', '    //Required methods\n', '    function approve(address _to, uint256 _tokenId) public;\n', '    function balanceOf(address _owner) public view returns (uint256 balance);\n', '    function implementsERC721() public pure returns (bool);\n', '    function ownerOf(uint256 _tokenId) public view returns (address addr);\n', '    function takeOwnership(uint256 _tokenId) public;\n', '    function totalSupply() public view returns (uint256 total);\n', '    function transferFrom(address _from, address _to, uint256 _tokenId) public;\n', '    function transfer(address _to, uint256 _tokenId) public;\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 tokenId);\n', '    event Approval(address indexed owner, address indexed approved, uint256 tokenId);\n', '\n', '    //Optional\n', '    //function name() public view returns (string name);\n', '    //function symbol() public view returns (string symbol);\n', '    //function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 tokenId);\n', '    //function tokenMetadata(uint256 _tokenId) public view returns (string infoUrl);\n', '}\n', '\n', '\n', 'contract Avatarium is Ownable, ERC721 {\n', '\n', '\n', '    // --- Events --- //\n', '\n', '\n', '    // @dev The Birth event is fired, whenever a new Avatar has been created.\n', '    event Birth(\n', '        uint256 tokenId, \n', '        string name, \n', '        address owner);\n', '\n', '    // @dev The TokenSold event is fired, whenever a token is sold.\n', '    event TokenSold(\n', '        uint256 tokenId, \n', '        uint256 oldPrice, \n', '        uint256 newPrice, \n', '        address prevOwner, \n', '        address winner, \n', '        string name);\n', '    \n', '    \n', '    // --- Constants --- //\n', '\n', '\n', '    // The name and the symbol of the NFT, as defined in ERC-721.\n', '    string public constant NAME = "Avatarium";\n', '    string public constant SYMBOL = "ΛV";\n', '\n', '    // Prices and iteration steps\n', '    uint256 private startingPrice = 0.02 ether;\n', '    uint256 private firstIterationLimit = 0.05 ether;\n', '    uint256 private secondIterationLimit = 0.5 ether;\n', '\n', '    // Addresses that can execute important functions.\n', '    address public addressCEO;\n', '    address public addressCOO;\n', '\n', '\n', '    // --- Storage --- //\n', '\n', '\n', '    // @dev A mapping from Avatar ID to the owner&#39;s address.\n', '    mapping (uint => address) public avatarIndexToOwner;\n', '\n', '    // @dev A mapping from the owner&#39;s address to the tokens it owns.\n', '    mapping (address => uint256) public ownershipTokenCount;\n', '\n', '    // @dev A mapping from Avatar&#39;s ID to an address that has been approved\n', '    // to call transferFrom().\n', '    mapping (uint256 => address) public avatarIndexToApproved;\n', '\n', '    // @dev A private mapping from Avatar&#39;s ID to its price.\n', '    mapping (uint256 => uint256) private avatarIndexToPrice;\n', '\n', '\n', '    // --- Datatypes --- //\n', '\n', '\n', '    // The main struct\n', '    struct Avatar {\n', '        string name;\n', '    }\n', '\n', '    Avatar[] public avatars;\n', '\n', '\n', '    // --- Access Modifiers --- //\n', '\n', '\n', '    // @dev Access only to the CEO-functionality.\n', '    modifier onlyCEO() {\n', '        require(msg.sender == addressCEO);\n', '        _;\n', '    }\n', '\n', '    // @dev Access only to the COO-functionality.\n', '    modifier onlyCOO() {\n', '        require(msg.sender == addressCOO);\n', '        _;\n', '    }\n', '\n', '    // @dev Access to the C-level in general.\n', '    modifier onlyCLevel() {\n', '        require(msg.sender == addressCEO || msg.sender == addressCOO);\n', '        _;\n', '    }\n', '\n', '\n', '    // --- Constructor --- //\n', '\n', '\n', '    function Avatarium() public {\n', '        addressCEO = msg.sender;\n', '        addressCOO = msg.sender;\n', '    }\n', '\n', '\n', '    // --- Public functions --- //\n', '\n', '\n', '    //@dev Assigns a new address as the CEO. Only available to the current CEO.\n', '    function setCEO(address _newCEO) public onlyCEO {\n', '        require(_newCEO != address(0));\n', '\n', '        addressCEO = _newCEO;\n', '    }\n', '\n', '    // @dev Assigns a new address as the COO. Only available to the current COO.\n', '    function setCOO(address _newCOO) public onlyCEO {\n', '        require(_newCOO != address(0));\n', '\n', '        addressCOO = _newCOO;\n', '    }\n', '\n', '    // @dev Grants another address the right to transfer a token via \n', '    // takeOwnership() and transferFrom()\n', '    function approve(address _to, uint256 _tokenId) public {\n', '        // Check the ownership\n', '        require(_owns(msg.sender, _tokenId));\n', '\n', '        avatarIndexToApproved[_tokenId] = _to;\n', '\n', '        // Fire the event\n', '        Approval(msg.sender, _to, _tokenId);\n', '    }\n', '\n', '    // @dev Checks the balanse of the address, ERC-721 compliance\n', '    function balanceOf(address _owner) public view returns (uint256 balance) {\n', '        return ownershipTokenCount[_owner];\n', '    }\n', '\n', '    // @dev Creates a new Avatar\n', '    function createAvatar(string _name, uint256 _rank) public onlyCLevel {\n', '        _createAvatar(_name, address(this), _rank);\n', '    }\n', '\n', '    // @dev Returns the information on a certain Avatar\n', '    function getAvatar(uint256 _tokenId) public view returns (\n', '        string avatarName,\n', '        uint256 sellingPrice,\n', '        address owner\n', '    ) {\n', '        Avatar storage avatar = avatars[_tokenId];\n', '        avatarName = avatar.name;\n', '        sellingPrice = avatarIndexToPrice[_tokenId];\n', '        owner = avatarIndexToOwner[_tokenId];\n', '    }\n', '\n', '    function implementsERC721() public pure returns (bool) {\n', '        return true;\n', '    }\n', '\n', '    // @dev Queries the owner of the token.\n', '    function ownerOf(uint256 _tokenId) public view returns (address owner) {\n', '        owner = avatarIndexToOwner[_tokenId];\n', '        require(owner != address(0));\n', '    }\n', '\n', '    function payout(address _to) public onlyCLevel {\n', '        _payout(_to);\n', '    }\n', '\n', '    // @dev Allows to purchase an Avatar for Ether.\n', '    function purchase(uint256 _tokenId) public payable {\n', '        address oldOwner = avatarIndexToOwner[_tokenId];\n', '        address newOwner = msg.sender;\n', '\n', '        uint256 sellingPrice = avatarIndexToPrice[_tokenId];\n', '\n', '        require(oldOwner != newOwner);\n', '        require(_addressNotNull(newOwner));\n', '        require(msg.value == sellingPrice);\n', '\n', '        uint256 payment = uint256(SafeMath.div(\n', '                                  SafeMath.mul(sellingPrice, 94), 100));\n', '        uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);\n', '\n', '        // Updating prices\n', '        if (sellingPrice < firstIterationLimit) {\n', '        // first stage\n', '            avatarIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 200), 94);\n', '        } else if (sellingPrice < secondIterationLimit) {\n', '        // second stage\n', '            avatarIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 120), 94);\n', '        } else {\n', '        // third stage\n', '            avatarIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 115), 94);\n', '        }\n', '\n', '        _transfer(oldOwner, newOwner, _tokenId);\n', '\n', '        // Pay previous token Owner, if it&#39;s not the contract\n', '        if (oldOwner != address(this)) {\n', '            oldOwner.transfer(payment);\n', '        }\n', '\n', '        // Fire event\n', '        \n', '        TokenSold(\n', '            _tokenId,\n', '            sellingPrice,\n', '            avatarIndexToPrice[_tokenId],\n', '            oldOwner,\n', '            newOwner,\n', '            avatars[_tokenId].name);\n', '\n', '        // Transferring excessess back to the sender\n', '        msg.sender.transfer(purchaseExcess);\n', '    }\n', '\n', '    // @dev Queries the price of a token.\n', '    function priceOf(uint256 _tokenId) public view returns (uint256 price) {\n', '        return avatarIndexToPrice[_tokenId];\n', '    }\n', '    \n', '    //@dev Allows pre-approved user to take ownership of a token.\n', '    function takeOwnership(uint256 _tokenId) public {\n', '        address newOwner = msg.sender;\n', '        address oldOwner = avatarIndexToOwner[_tokenId];\n', '\n', '        // Safety check to prevent against an unexpected 0x0 default.\n', '        require(_addressNotNull(newOwner));\n', '\n', '        //Making sure transfer is approved\n', '        require(_approved(newOwner, _tokenId));\n', '\n', '        _transfer(oldOwner, newOwner, _tokenId);\n', '    }\n', '\n', '    // @dev Required for ERC-721 compliance.\n', '    function totalSupply() public view returns (uint256 total) {\n', '        return avatars.length;\n', '    }\n', '\n', '    // @dev Owner initates the transfer of the token to another account.\n', '    function transfer(\n', '        address _to,\n', '        uint256 _tokenId\n', '    ) public {\n', '        require(_owns(msg.sender, _tokenId));\n', '        require(_addressNotNull(_to));\n', '\n', '        _transfer(msg.sender, _to, _tokenId);\n', '    }\n', '\n', '    // @dev Third-party initiates transfer of token from address _from to\n', '    // address _to.\n', '    function transferFrom(\n', '        address _from,\n', '        address _to,\n', '        uint256 _tokenId\n', '    ) public {\n', '        require(_owns(_from, _tokenId));\n', '        require(_approved(_to, _tokenId));\n', '        require(_addressNotNull(_to));\n', '\n', '        _transfer(_from, _to, _tokenId);\n', '    }\n', '\n', '\n', '    // --- Private Functions --- // \n', '\n', '\n', '    // Safety check on _to address to prevent against an unexpected 0x0 default.\n', '    function _addressNotNull(address _to) private pure returns (bool) {\n', '        return _to != address(0);\n', '    }\n', '\n', '    // For checking approval of transfer for address _to\n', '    function _approved(address _to, uint256 _tokenId)\n', '    private \n', '    view \n', '    returns (bool) {\n', '        return avatarIndexToApproved[_tokenId] == _to;\n', '    }\n', '\n', '    // For creating Avatars.\n', '    function _createAvatar(\n', '        string _name,\n', '        address _owner, \n', '        uint256 _rank) \n', '        private {\n', '    \n', '    // Getting the startingPrice\n', '    uint256 _price;\n', '    if (_rank == 1) {\n', '        _price = startingPrice;\n', '    } else if (_rank == 2) {\n', '        _price = 2 * startingPrice;\n', '    } else if (_rank == 3) {\n', '        _price = SafeMath.mul(4, startingPrice);\n', '    } else if (_rank == 4) {\n', '        _price = SafeMath.mul(8, startingPrice);\n', '    } else if (_rank == 5) {\n', '        _price = SafeMath.mul(16, startingPrice);\n', '    } else if (_rank == 6) {\n', '        _price = SafeMath.mul(32, startingPrice);\n', '    } else if (_rank == 7) {\n', '        _price = SafeMath.mul(64, startingPrice);\n', '    } else if (_rank == 8) {\n', '        _price = SafeMath.mul(128, startingPrice);\n', '    } else if (_rank == 9) {\n', '        _price = SafeMath.mul(256, startingPrice);\n', '    } \n', '\n', '    Avatar memory _avatar = Avatar({name: _name});\n', '\n', '    uint256 newAvatarId = avatars.push(_avatar) - 1;\n', '\n', '    avatarIndexToPrice[newAvatarId] = _price;\n', '\n', '    // Fire event\n', '    Birth(newAvatarId, _name, _owner);\n', '\n', '    // Transfer token to the contract\n', '    _transfer(address(0), _owner, newAvatarId);\n', '    }\n', '\n', '    // @dev Checks for token ownership.\n', '    function _owns(address claimant, uint256 _tokenId) \n', '    private \n', '    view \n', '    returns (bool) {\n', '        return claimant == avatarIndexToOwner[_tokenId];\n', '    }\n', '\n', '    // @dev Pays out balance on contract\n', '    function _payout(address _to) private {\n', '        if (_to == address(0)) {\n', '            addressCEO.transfer(this.balance);\n', '        } else {\n', '            _to.transfer(this.balance);\n', '        }\n', '    }\n', '\n', '    // @dev Assigns ownership of a specific Avatar to an address.\n', '    function _transfer(address _from, address _to, uint256 _tokenId) private {\n', '        ownershipTokenCount[_to]++;\n', '        avatarIndexToOwner[_tokenId] = _to;\n', '\n', '        if (_from != address(0)) {\n', '            ownershipTokenCount[_from]--;\n', '            delete avatarIndexToApproved[_tokenId];\n', '        }\n', '\n', '        // Fire event\n', '        Transfer(_from, _to, _tokenId);\n', '    }\n', '}']
['pragma solidity ^0.4.18;\n', '\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '  /**\n', '  * @dev Multiplies two numbers, throws on overflow.\n', '  */\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    assert(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Integer division of two numbers, truncating the quotient.\n', '  */\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  /**\n', '  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '  */\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  /**\n', '  * @dev Adds two numbers, throws on overflow.\n', '  */\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '\n', '/*\n', ' * Ownable\n', ' *\n', ' * Base contract with an owner.\n', ' * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.\n', ' */\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '    function Ownable() {\n', '    owner = msg.sender;\n', '    }\n', '\n', '  modifier onlyOwner() {\n', '    if (msg.sender == owner)\n', '      _;\n', '  }\n', '\n', '  function transferOwnership(address newOwner) onlyOwner {\n', '    if (newOwner != address(0)) owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '// @title Interface for contracts conforming to ERC-721 Non-Fungible Tokens\n', '// @author Dieter Shirley dete@axiomzen.co (httpsgithub.comdete)\n', 'contract ERC721 {\n', '    //Required methods\n', '    function approve(address _to, uint256 _tokenId) public;\n', '    function balanceOf(address _owner) public view returns (uint256 balance);\n', '    function implementsERC721() public pure returns (bool);\n', '    function ownerOf(uint256 _tokenId) public view returns (address addr);\n', '    function takeOwnership(uint256 _tokenId) public;\n', '    function totalSupply() public view returns (uint256 total);\n', '    function transferFrom(address _from, address _to, uint256 _tokenId) public;\n', '    function transfer(address _to, uint256 _tokenId) public;\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 tokenId);\n', '    event Approval(address indexed owner, address indexed approved, uint256 tokenId);\n', '\n', '    //Optional\n', '    //function name() public view returns (string name);\n', '    //function symbol() public view returns (string symbol);\n', '    //function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 tokenId);\n', '    //function tokenMetadata(uint256 _tokenId) public view returns (string infoUrl);\n', '}\n', '\n', '\n', 'contract Avatarium is Ownable, ERC721 {\n', '\n', '\n', '    // --- Events --- //\n', '\n', '\n', '    // @dev The Birth event is fired, whenever a new Avatar has been created.\n', '    event Birth(\n', '        uint256 tokenId, \n', '        string name, \n', '        address owner);\n', '\n', '    // @dev The TokenSold event is fired, whenever a token is sold.\n', '    event TokenSold(\n', '        uint256 tokenId, \n', '        uint256 oldPrice, \n', '        uint256 newPrice, \n', '        address prevOwner, \n', '        address winner, \n', '        string name);\n', '    \n', '    \n', '    // --- Constants --- //\n', '\n', '\n', '    // The name and the symbol of the NFT, as defined in ERC-721.\n', '    string public constant NAME = "Avatarium";\n', '    string public constant SYMBOL = "ΛV";\n', '\n', '    // Prices and iteration steps\n', '    uint256 private startingPrice = 0.02 ether;\n', '    uint256 private firstIterationLimit = 0.05 ether;\n', '    uint256 private secondIterationLimit = 0.5 ether;\n', '\n', '    // Addresses that can execute important functions.\n', '    address public addressCEO;\n', '    address public addressCOO;\n', '\n', '\n', '    // --- Storage --- //\n', '\n', '\n', "    // @dev A mapping from Avatar ID to the owner's address.\n", '    mapping (uint => address) public avatarIndexToOwner;\n', '\n', "    // @dev A mapping from the owner's address to the tokens it owns.\n", '    mapping (address => uint256) public ownershipTokenCount;\n', '\n', "    // @dev A mapping from Avatar's ID to an address that has been approved\n", '    // to call transferFrom().\n', '    mapping (uint256 => address) public avatarIndexToApproved;\n', '\n', "    // @dev A private mapping from Avatar's ID to its price.\n", '    mapping (uint256 => uint256) private avatarIndexToPrice;\n', '\n', '\n', '    // --- Datatypes --- //\n', '\n', '\n', '    // The main struct\n', '    struct Avatar {\n', '        string name;\n', '    }\n', '\n', '    Avatar[] public avatars;\n', '\n', '\n', '    // --- Access Modifiers --- //\n', '\n', '\n', '    // @dev Access only to the CEO-functionality.\n', '    modifier onlyCEO() {\n', '        require(msg.sender == addressCEO);\n', '        _;\n', '    }\n', '\n', '    // @dev Access only to the COO-functionality.\n', '    modifier onlyCOO() {\n', '        require(msg.sender == addressCOO);\n', '        _;\n', '    }\n', '\n', '    // @dev Access to the C-level in general.\n', '    modifier onlyCLevel() {\n', '        require(msg.sender == addressCEO || msg.sender == addressCOO);\n', '        _;\n', '    }\n', '\n', '\n', '    // --- Constructor --- //\n', '\n', '\n', '    function Avatarium() public {\n', '        addressCEO = msg.sender;\n', '        addressCOO = msg.sender;\n', '    }\n', '\n', '\n', '    // --- Public functions --- //\n', '\n', '\n', '    //@dev Assigns a new address as the CEO. Only available to the current CEO.\n', '    function setCEO(address _newCEO) public onlyCEO {\n', '        require(_newCEO != address(0));\n', '\n', '        addressCEO = _newCEO;\n', '    }\n', '\n', '    // @dev Assigns a new address as the COO. Only available to the current COO.\n', '    function setCOO(address _newCOO) public onlyCEO {\n', '        require(_newCOO != address(0));\n', '\n', '        addressCOO = _newCOO;\n', '    }\n', '\n', '    // @dev Grants another address the right to transfer a token via \n', '    // takeOwnership() and transferFrom()\n', '    function approve(address _to, uint256 _tokenId) public {\n', '        // Check the ownership\n', '        require(_owns(msg.sender, _tokenId));\n', '\n', '        avatarIndexToApproved[_tokenId] = _to;\n', '\n', '        // Fire the event\n', '        Approval(msg.sender, _to, _tokenId);\n', '    }\n', '\n', '    // @dev Checks the balanse of the address, ERC-721 compliance\n', '    function balanceOf(address _owner) public view returns (uint256 balance) {\n', '        return ownershipTokenCount[_owner];\n', '    }\n', '\n', '    // @dev Creates a new Avatar\n', '    function createAvatar(string _name, uint256 _rank) public onlyCLevel {\n', '        _createAvatar(_name, address(this), _rank);\n', '    }\n', '\n', '    // @dev Returns the information on a certain Avatar\n', '    function getAvatar(uint256 _tokenId) public view returns (\n', '        string avatarName,\n', '        uint256 sellingPrice,\n', '        address owner\n', '    ) {\n', '        Avatar storage avatar = avatars[_tokenId];\n', '        avatarName = avatar.name;\n', '        sellingPrice = avatarIndexToPrice[_tokenId];\n', '        owner = avatarIndexToOwner[_tokenId];\n', '    }\n', '\n', '    function implementsERC721() public pure returns (bool) {\n', '        return true;\n', '    }\n', '\n', '    // @dev Queries the owner of the token.\n', '    function ownerOf(uint256 _tokenId) public view returns (address owner) {\n', '        owner = avatarIndexToOwner[_tokenId];\n', '        require(owner != address(0));\n', '    }\n', '\n', '    function payout(address _to) public onlyCLevel {\n', '        _payout(_to);\n', '    }\n', '\n', '    // @dev Allows to purchase an Avatar for Ether.\n', '    function purchase(uint256 _tokenId) public payable {\n', '        address oldOwner = avatarIndexToOwner[_tokenId];\n', '        address newOwner = msg.sender;\n', '\n', '        uint256 sellingPrice = avatarIndexToPrice[_tokenId];\n', '\n', '        require(oldOwner != newOwner);\n', '        require(_addressNotNull(newOwner));\n', '        require(msg.value == sellingPrice);\n', '\n', '        uint256 payment = uint256(SafeMath.div(\n', '                                  SafeMath.mul(sellingPrice, 94), 100));\n', '        uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);\n', '\n', '        // Updating prices\n', '        if (sellingPrice < firstIterationLimit) {\n', '        // first stage\n', '            avatarIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 200), 94);\n', '        } else if (sellingPrice < secondIterationLimit) {\n', '        // second stage\n', '            avatarIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 120), 94);\n', '        } else {\n', '        // third stage\n', '            avatarIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 115), 94);\n', '        }\n', '\n', '        _transfer(oldOwner, newOwner, _tokenId);\n', '\n', "        // Pay previous token Owner, if it's not the contract\n", '        if (oldOwner != address(this)) {\n', '            oldOwner.transfer(payment);\n', '        }\n', '\n', '        // Fire event\n', '        \n', '        TokenSold(\n', '            _tokenId,\n', '            sellingPrice,\n', '            avatarIndexToPrice[_tokenId],\n', '            oldOwner,\n', '            newOwner,\n', '            avatars[_tokenId].name);\n', '\n', '        // Transferring excessess back to the sender\n', '        msg.sender.transfer(purchaseExcess);\n', '    }\n', '\n', '    // @dev Queries the price of a token.\n', '    function priceOf(uint256 _tokenId) public view returns (uint256 price) {\n', '        return avatarIndexToPrice[_tokenId];\n', '    }\n', '    \n', '    //@dev Allows pre-approved user to take ownership of a token.\n', '    function takeOwnership(uint256 _tokenId) public {\n', '        address newOwner = msg.sender;\n', '        address oldOwner = avatarIndexToOwner[_tokenId];\n', '\n', '        // Safety check to prevent against an unexpected 0x0 default.\n', '        require(_addressNotNull(newOwner));\n', '\n', '        //Making sure transfer is approved\n', '        require(_approved(newOwner, _tokenId));\n', '\n', '        _transfer(oldOwner, newOwner, _tokenId);\n', '    }\n', '\n', '    // @dev Required for ERC-721 compliance.\n', '    function totalSupply() public view returns (uint256 total) {\n', '        return avatars.length;\n', '    }\n', '\n', '    // @dev Owner initates the transfer of the token to another account.\n', '    function transfer(\n', '        address _to,\n', '        uint256 _tokenId\n', '    ) public {\n', '        require(_owns(msg.sender, _tokenId));\n', '        require(_addressNotNull(_to));\n', '\n', '        _transfer(msg.sender, _to, _tokenId);\n', '    }\n', '\n', '    // @dev Third-party initiates transfer of token from address _from to\n', '    // address _to.\n', '    function transferFrom(\n', '        address _from,\n', '        address _to,\n', '        uint256 _tokenId\n', '    ) public {\n', '        require(_owns(_from, _tokenId));\n', '        require(_approved(_to, _tokenId));\n', '        require(_addressNotNull(_to));\n', '\n', '        _transfer(_from, _to, _tokenId);\n', '    }\n', '\n', '\n', '    // --- Private Functions --- // \n', '\n', '\n', '    // Safety check on _to address to prevent against an unexpected 0x0 default.\n', '    function _addressNotNull(address _to) private pure returns (bool) {\n', '        return _to != address(0);\n', '    }\n', '\n', '    // For checking approval of transfer for address _to\n', '    function _approved(address _to, uint256 _tokenId)\n', '    private \n', '    view \n', '    returns (bool) {\n', '        return avatarIndexToApproved[_tokenId] == _to;\n', '    }\n', '\n', '    // For creating Avatars.\n', '    function _createAvatar(\n', '        string _name,\n', '        address _owner, \n', '        uint256 _rank) \n', '        private {\n', '    \n', '    // Getting the startingPrice\n', '    uint256 _price;\n', '    if (_rank == 1) {\n', '        _price = startingPrice;\n', '    } else if (_rank == 2) {\n', '        _price = 2 * startingPrice;\n', '    } else if (_rank == 3) {\n', '        _price = SafeMath.mul(4, startingPrice);\n', '    } else if (_rank == 4) {\n', '        _price = SafeMath.mul(8, startingPrice);\n', '    } else if (_rank == 5) {\n', '        _price = SafeMath.mul(16, startingPrice);\n', '    } else if (_rank == 6) {\n', '        _price = SafeMath.mul(32, startingPrice);\n', '    } else if (_rank == 7) {\n', '        _price = SafeMath.mul(64, startingPrice);\n', '    } else if (_rank == 8) {\n', '        _price = SafeMath.mul(128, startingPrice);\n', '    } else if (_rank == 9) {\n', '        _price = SafeMath.mul(256, startingPrice);\n', '    } \n', '\n', '    Avatar memory _avatar = Avatar({name: _name});\n', '\n', '    uint256 newAvatarId = avatars.push(_avatar) - 1;\n', '\n', '    avatarIndexToPrice[newAvatarId] = _price;\n', '\n', '    // Fire event\n', '    Birth(newAvatarId, _name, _owner);\n', '\n', '    // Transfer token to the contract\n', '    _transfer(address(0), _owner, newAvatarId);\n', '    }\n', '\n', '    // @dev Checks for token ownership.\n', '    function _owns(address claimant, uint256 _tokenId) \n', '    private \n', '    view \n', '    returns (bool) {\n', '        return claimant == avatarIndexToOwner[_tokenId];\n', '    }\n', '\n', '    // @dev Pays out balance on contract\n', '    function _payout(address _to) private {\n', '        if (_to == address(0)) {\n', '            addressCEO.transfer(this.balance);\n', '        } else {\n', '            _to.transfer(this.balance);\n', '        }\n', '    }\n', '\n', '    // @dev Assigns ownership of a specific Avatar to an address.\n', '    function _transfer(address _from, address _to, uint256 _tokenId) private {\n', '        ownershipTokenCount[_to]++;\n', '        avatarIndexToOwner[_tokenId] = _to;\n', '\n', '        if (_from != address(0)) {\n', '            ownershipTokenCount[_from]--;\n', '            delete avatarIndexToApproved[_tokenId];\n', '        }\n', '\n', '        // Fire event\n', '        Transfer(_from, _to, _tokenId);\n', '    }\n', '}']