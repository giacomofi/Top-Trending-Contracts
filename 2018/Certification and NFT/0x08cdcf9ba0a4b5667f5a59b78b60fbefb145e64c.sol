['pragma solidity ^0.4.18;\n', '\n', 'library SafeMath {\n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '/// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens\n', 'contract ERC721 {\n', '    // Required methods\n', '    function approve(address _to, uint256 _tokenId) public;\n', '    function balanceOf(address _owner) public view returns (uint256 balance);\n', '    function implementsERC721() public pure returns (bool);\n', '    function ownerOf(uint256 _tokenId) public view returns (address addr);\n', '    function takeOwnership(uint256 _tokenId) public;\n', '    function totalSupply() public view returns (uint256 total);\n', '    function transferFrom(address _from, address _to, uint256 _tokenId) public;\n', '    function transfer(address _to, uint256 _tokenId) public;\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 tokenId);\n', '    event Approval(address indexed owner, address indexed approved, uint256 tokenId);\n', '}\n', '\n', 'contract WorldCupToken is ERC721 {\n', '\n', '    /*****------ EVENTS -----*****/\n', '    // @dev whenever a token is sold.\n', '    event WorldCupTokenWereSold(address indexed curOwner, uint256 indexed tokenId, uint256 oldPrice, uint256 newPrice, address indexed prevOwner, uint256 traddingTime);//indexed\n', '    // @dev whenever Share Bonus.\n', '\tevent ShareBonus(address indexed toOwner, uint256 indexed tokenId, uint256 indexed traddingTime, uint256 remainingAmount);\n', '\t// @dev Present. \n', '    event Present(address indexed fromAddress, address indexed toAddress, uint256 amount, uint256 presentTime);\n', '    // @dev Transfer event as defined in ERC721. \n', '    event Transfer(address from, address to, uint256 tokenId);\n', '\n', '    /*****------- CONSTANTS -------******/\n', '    mapping (uint256 => address) public worldCupIdToOwnerAddress;  //@dev A mapping from world cup team id to the address that owns them. \n', '    mapping (address => uint256) private ownerAddressToTokenCount; //@dev A mapping from owner address to count of tokens that address owns.\n', '    mapping (uint256 => address) public worldCupIdToAddressForApproved; // @dev A mapping from token id to an address that has been approved to call.\n', '    mapping (uint256 => uint256) private worldCupIdToPrice; // @dev A mapping from token id to the price of the token.\n', '    //mapping (uint256 => uint256) private worldCupIdToOldPrice; // @dev A mapping from token id to the old price of the token.\n', '    string[] private worldCupTeamDescribe;\n', '\tuint256 private SHARE_BONUS_TIME = uint256(now);\n', '    address public ceoAddress;\n', '    address public cooAddress;\n', '\n', '    /*****------- MODIFIERS -------******/\n', '    modifier onlyCEO() {\n', '        require(msg.sender == ceoAddress);\n', '        _;\n', '    }\n', '\n', '    modifier onlyCLevel() {\n', '        require(\n', '            msg.sender == ceoAddress ||\n', '            msg.sender == cooAddress\n', '        );\n', '        _;\n', '    }\n', '\n', '    function setCEO(address _newCEO) public onlyCEO {\n', '        require(_newCEO != address(0));\n', '        ceoAddress = _newCEO;\n', '    }\n', '\n', '    function setCOO(address _newCOO) public onlyCEO {\n', '        require(_newCOO != address(0));\n', '        cooAddress = _newCOO;\n', '    }\n', '\t\n', '\tfunction destroy() public onlyCEO {\n', '\t\tselfdestruct(ceoAddress);\n', '    }\n', '\t\n', '\tfunction payAllOut() public onlyCLevel {\n', '       ceoAddress.transfer(this.balance);\n', '    }\n', '\n', '    /*****------- CONSTRUCTOR -------******/\n', '    function WorldCupToken() public {\n', '        ceoAddress = msg.sender;\n', '        cooAddress = msg.sender;\n', '\t    for (uint256 i = 0; i < 32; i++) {\n', '\t\t    uint256 newWorldCupTeamId = worldCupTeamDescribe.push("I love world cup!") - 1;\n', '            worldCupIdToPrice[newWorldCupTeamId] = 0 ether;//SafeMath.sub(uint256(3.2 ether), SafeMath.mul(uint256(0.1 ether), i));\n', '\t        //worldCupIdToOldPrice[newWorldCupTeamId] = 0 ether;\n', '            _transfer(address(0), msg.sender, newWorldCupTeamId);\n', '\t    }\n', '    }\n', '\n', '    /*****------- PUBLIC FUNCTIONS -------******/\n', '    function approve(address _to, uint256 _tokenId) public {\n', '        require(_isOwner(msg.sender, _tokenId));\n', '        worldCupIdToAddressForApproved[_tokenId] = _to;\n', '        Approval(msg.sender, _to, _tokenId);\n', '    }\n', '\n', '    /// For querying balance of a particular account\n', '    function balanceOf(address _owner) public view returns (uint256 balance) {\n', '        return ownerAddressToTokenCount[_owner];\n', '    }\n', '\n', '    /// @notice Returns all the world cup team information by token id.\n', '    function getWorlCupByID(uint256 _tokenId) public view returns (string wctDesc, uint256 sellingPrice, address owner) {\n', '        wctDesc = worldCupTeamDescribe[_tokenId];\n', '        sellingPrice = worldCupIdToPrice[_tokenId];\n', '        owner = worldCupIdToOwnerAddress[_tokenId];\n', '    }\n', '\n', '    function implementsERC721() public pure returns (bool) {\n', '        return true;\n', '    }\n', '\n', '    /// @dev Required for ERC-721 compliance.\n', '    function name() public pure returns (string) {\n', '        return "WorldCupToken";\n', '    }\n', '  \n', '    /// @dev Required for ERC-721 compliance.\n', '    function symbol() public pure returns (string) {\n', '        return "WCT";\n', '    }\n', '\n', '    // @dev Required for ERC-721 compliance.\n', '    function ownerOf(uint256 _tokenId) public view returns (address owner) {\n', '        owner = worldCupIdToOwnerAddress[_tokenId];\n', '        require(owner != address(0));\n', '        return owner;\n', '    }\n', '  \n', '    function setWorldCupTeamDesc(uint256 _tokenId, string descOfOwner) public {\n', '        if(ownerOf(_tokenId) == msg.sender){\n', '\t        worldCupTeamDescribe[_tokenId] = descOfOwner;\n', '\t    }\n', '    }\n', '\n', '\t/// Allows someone to send ether and obtain the token\n', '    ///function PresentToCEO() public payable {\n', '\t///    ceoAddress.transfer(msg.value);\n', '\t///\tPresent(msg.sender, ceoAddress, msg.value, uint256(now));\n', '\t///}\n', '\t\n', '    // Allows someone to send ether and obtain the token\n', '    function buyWorldCupTeamToken(uint256 _tokenId) public payable {\n', '        address oldOwner = worldCupIdToOwnerAddress[_tokenId];\n', '        address newOwner = msg.sender;\n', '        require(oldOwner != newOwner); // Make sure token owner is not sending to self\n', '        require(_addressNotNull(newOwner)); //Safety check to prevent against an unexpected 0x0 default.\n', '\n', '\t    uint256 oldSoldPrice = worldCupIdToPrice[_tokenId];//worldCupIdToOldPrice[_tokenId];\n', '\t    uint256 diffPrice = SafeMath.sub(msg.value, oldSoldPrice);\n', '\t    uint256 priceOfOldOwner = SafeMath.add(oldSoldPrice, SafeMath.div(diffPrice, 2));\n', '\t    uint256 priceOfDevelop = SafeMath.div(diffPrice, 4);\n', '\t    worldCupIdToPrice[_tokenId] = msg.value;//SafeMath.add(msg.value, SafeMath.div(msg.value, 10));\n', '\t    //worldCupIdToOldPrice[_tokenId] = msg.value;\n', '\n', '        _transfer(oldOwner, newOwner, _tokenId);\n', '        if (oldOwner != address(this)) {\n', '\t        oldOwner.transfer(priceOfOldOwner);\n', '        }\n', '\t    ceoAddress.transfer(priceOfDevelop);\n', '\t    if(this.balance >= uint256(3.2 ether)){\n', '            if((uint256(now) - SHARE_BONUS_TIME) >= 86400){\n', '\t\t        for(uint256 i=0; i<32; i++){\n', '\t\t            worldCupIdToOwnerAddress[i].transfer(0.1 ether);\n', '\t\t\t\t\tShareBonus(worldCupIdToOwnerAddress[i], i, uint256(now), this.balance);\n', '\t\t        }\n', '\t\t\t    SHARE_BONUS_TIME = uint256(now);\n', '\t\t\t    //ShareBonus(SHARE_BONUS_TIME, this.balance);\n', '\t\t    }\n', '\t    }\n', '\t    WorldCupTokenWereSold(newOwner, _tokenId, oldSoldPrice, msg.value, oldOwner, uint256(now));\n', '\t}\n', '\n', '    function priceOf(uint256 _tokenId) public view returns (uint256 price) {\n', '        return worldCupIdToPrice[_tokenId];\n', '    }\n', '\n', '    /// @dev Required for ERC-721 compliance.\n', '    function takeOwnership(uint256 _tokenId) public {\n', '        address newOwner = msg.sender;\n', '        address oldOwner = worldCupIdToOwnerAddress[_tokenId];\n', '\n', '        // Safety check to prevent against an unexpected 0x0 default.\n', '        require(_addressNotNull(newOwner));\n', '\n', '        // Making sure transfer is approved\n', '        require(_approved(newOwner, _tokenId));\n', '\n', '        _transfer(oldOwner, newOwner, _tokenId);\n', '    }\n', '\n', '    function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {\n', '        uint256 tokenCount = balanceOf(_owner);\n', '        if (tokenCount == 0) {\n', '            return new uint256[](0);\n', '        } else {\n', '            uint256[] memory result = new uint256[](tokenCount);\n', '            uint256 totalCars = totalSupply();\n', '            uint256 resultIndex = 0;\n', '\n', '            uint256 carId;\n', '            for (carId = 0; carId <= totalCars; carId++) {\n', '                if (worldCupIdToOwnerAddress[carId] == _owner) {\n', '                    result[resultIndex] = carId;\n', '                    resultIndex++;\n', '                }\n', '            }\n', '            return result;\n', '        }\n', '    }\n', '  \n', '    function getCEO() public view returns (address ceoAddr) {\n', '        return ceoAddress;\n', '    }\n', '\n', '    //Required for ERC-721 compliance.\n', '    function totalSupply() public view returns (uint256 total) {\n', '        return worldCupTeamDescribe.length;\n', '    }\n', '  \n', '    //return BonusPool $\n', '    function getBonusPool() public view returns (uint256) {\n', '        return this.balance;\n', '    }\n', '  \n', '    function getTimeFromPrize() public view returns (uint256) {\n', '        return uint256(now) - SHARE_BONUS_TIME;\n', '    }\n', '\n', '    /// @dev Required for ERC-721 compliance.\n', '    function transfer(address _to, uint256 _tokenId) public {\n', '        require(_isOwner(msg.sender, _tokenId));\n', '        require(_addressNotNull(_to));\n', '\n', '        _transfer(msg.sender, _to, _tokenId);\n', '    }\n', '\n', '    /// @dev Required for ERC-721 compliance.\n', '    function transferFrom(address _from, address _to, uint256 _tokenId) public {\n', '        require(_isOwner(_from, _tokenId));\n', '        require(_approved(_to, _tokenId));\n', '        require(_addressNotNull(_to));\n', '\n', '        _transfer(_from, _to, _tokenId);\n', '    }\n', '\n', '    /********----------- PRIVATE FUNCTIONS ------------********/\n', '    function _addressNotNull(address _to) private pure returns (bool) {\n', '        return _to != address(0);\n', '    }\n', '\n', '    function _approved(address _to, uint256 _tokenId) private view returns (bool) {\n', '        return worldCupIdToAddressForApproved[_tokenId] == _to;\n', '    }\n', '\n', '    function _isOwner(address checkAddress, uint256 _tokenId) private view returns (bool) {\n', '        return checkAddress == worldCupIdToOwnerAddress[_tokenId];\n', '    }\n', '\n', '    function _transfer(address _from, address _to, uint256 _tokenId) private {\n', '        ownerAddressToTokenCount[_to]++;\n', '        worldCupIdToOwnerAddress[_tokenId] = _to;  //transfer ownership\n', '\n', '        if (_from != address(0)) {\n', '            ownerAddressToTokenCount[_from]--;\n', '            delete worldCupIdToAddressForApproved[_tokenId];\n', '        }\n', '        Transfer(_from, _to, _tokenId);\n', '    }\n', '}']
['pragma solidity ^0.4.18;\n', '\n', 'library SafeMath {\n', '    /**\n', '    * @dev Multiplies two numbers, throws on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two numbers, truncating the quotient.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two numbers, throws on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '/// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens\n', 'contract ERC721 {\n', '    // Required methods\n', '    function approve(address _to, uint256 _tokenId) public;\n', '    function balanceOf(address _owner) public view returns (uint256 balance);\n', '    function implementsERC721() public pure returns (bool);\n', '    function ownerOf(uint256 _tokenId) public view returns (address addr);\n', '    function takeOwnership(uint256 _tokenId) public;\n', '    function totalSupply() public view returns (uint256 total);\n', '    function transferFrom(address _from, address _to, uint256 _tokenId) public;\n', '    function transfer(address _to, uint256 _tokenId) public;\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 tokenId);\n', '    event Approval(address indexed owner, address indexed approved, uint256 tokenId);\n', '}\n', '\n', 'contract WorldCupToken is ERC721 {\n', '\n', '    /*****------ EVENTS -----*****/\n', '    // @dev whenever a token is sold.\n', '    event WorldCupTokenWereSold(address indexed curOwner, uint256 indexed tokenId, uint256 oldPrice, uint256 newPrice, address indexed prevOwner, uint256 traddingTime);//indexed\n', '    // @dev whenever Share Bonus.\n', '\tevent ShareBonus(address indexed toOwner, uint256 indexed tokenId, uint256 indexed traddingTime, uint256 remainingAmount);\n', '\t// @dev Present. \n', '    event Present(address indexed fromAddress, address indexed toAddress, uint256 amount, uint256 presentTime);\n', '    // @dev Transfer event as defined in ERC721. \n', '    event Transfer(address from, address to, uint256 tokenId);\n', '\n', '    /*****------- CONSTANTS -------******/\n', '    mapping (uint256 => address) public worldCupIdToOwnerAddress;  //@dev A mapping from world cup team id to the address that owns them. \n', '    mapping (address => uint256) private ownerAddressToTokenCount; //@dev A mapping from owner address to count of tokens that address owns.\n', '    mapping (uint256 => address) public worldCupIdToAddressForApproved; // @dev A mapping from token id to an address that has been approved to call.\n', '    mapping (uint256 => uint256) private worldCupIdToPrice; // @dev A mapping from token id to the price of the token.\n', '    //mapping (uint256 => uint256) private worldCupIdToOldPrice; // @dev A mapping from token id to the old price of the token.\n', '    string[] private worldCupTeamDescribe;\n', '\tuint256 private SHARE_BONUS_TIME = uint256(now);\n', '    address public ceoAddress;\n', '    address public cooAddress;\n', '\n', '    /*****------- MODIFIERS -------******/\n', '    modifier onlyCEO() {\n', '        require(msg.sender == ceoAddress);\n', '        _;\n', '    }\n', '\n', '    modifier onlyCLevel() {\n', '        require(\n', '            msg.sender == ceoAddress ||\n', '            msg.sender == cooAddress\n', '        );\n', '        _;\n', '    }\n', '\n', '    function setCEO(address _newCEO) public onlyCEO {\n', '        require(_newCEO != address(0));\n', '        ceoAddress = _newCEO;\n', '    }\n', '\n', '    function setCOO(address _newCOO) public onlyCEO {\n', '        require(_newCOO != address(0));\n', '        cooAddress = _newCOO;\n', '    }\n', '\t\n', '\tfunction destroy() public onlyCEO {\n', '\t\tselfdestruct(ceoAddress);\n', '    }\n', '\t\n', '\tfunction payAllOut() public onlyCLevel {\n', '       ceoAddress.transfer(this.balance);\n', '    }\n', '\n', '    /*****------- CONSTRUCTOR -------******/\n', '    function WorldCupToken() public {\n', '        ceoAddress = msg.sender;\n', '        cooAddress = msg.sender;\n', '\t    for (uint256 i = 0; i < 32; i++) {\n', '\t\t    uint256 newWorldCupTeamId = worldCupTeamDescribe.push("I love world cup!") - 1;\n', '            worldCupIdToPrice[newWorldCupTeamId] = 0 ether;//SafeMath.sub(uint256(3.2 ether), SafeMath.mul(uint256(0.1 ether), i));\n', '\t        //worldCupIdToOldPrice[newWorldCupTeamId] = 0 ether;\n', '            _transfer(address(0), msg.sender, newWorldCupTeamId);\n', '\t    }\n', '    }\n', '\n', '    /*****------- PUBLIC FUNCTIONS -------******/\n', '    function approve(address _to, uint256 _tokenId) public {\n', '        require(_isOwner(msg.sender, _tokenId));\n', '        worldCupIdToAddressForApproved[_tokenId] = _to;\n', '        Approval(msg.sender, _to, _tokenId);\n', '    }\n', '\n', '    /// For querying balance of a particular account\n', '    function balanceOf(address _owner) public view returns (uint256 balance) {\n', '        return ownerAddressToTokenCount[_owner];\n', '    }\n', '\n', '    /// @notice Returns all the world cup team information by token id.\n', '    function getWorlCupByID(uint256 _tokenId) public view returns (string wctDesc, uint256 sellingPrice, address owner) {\n', '        wctDesc = worldCupTeamDescribe[_tokenId];\n', '        sellingPrice = worldCupIdToPrice[_tokenId];\n', '        owner = worldCupIdToOwnerAddress[_tokenId];\n', '    }\n', '\n', '    function implementsERC721() public pure returns (bool) {\n', '        return true;\n', '    }\n', '\n', '    /// @dev Required for ERC-721 compliance.\n', '    function name() public pure returns (string) {\n', '        return "WorldCupToken";\n', '    }\n', '  \n', '    /// @dev Required for ERC-721 compliance.\n', '    function symbol() public pure returns (string) {\n', '        return "WCT";\n', '    }\n', '\n', '    // @dev Required for ERC-721 compliance.\n', '    function ownerOf(uint256 _tokenId) public view returns (address owner) {\n', '        owner = worldCupIdToOwnerAddress[_tokenId];\n', '        require(owner != address(0));\n', '        return owner;\n', '    }\n', '  \n', '    function setWorldCupTeamDesc(uint256 _tokenId, string descOfOwner) public {\n', '        if(ownerOf(_tokenId) == msg.sender){\n', '\t        worldCupTeamDescribe[_tokenId] = descOfOwner;\n', '\t    }\n', '    }\n', '\n', '\t/// Allows someone to send ether and obtain the token\n', '    ///function PresentToCEO() public payable {\n', '\t///    ceoAddress.transfer(msg.value);\n', '\t///\tPresent(msg.sender, ceoAddress, msg.value, uint256(now));\n', '\t///}\n', '\t\n', '    // Allows someone to send ether and obtain the token\n', '    function buyWorldCupTeamToken(uint256 _tokenId) public payable {\n', '        address oldOwner = worldCupIdToOwnerAddress[_tokenId];\n', '        address newOwner = msg.sender;\n', '        require(oldOwner != newOwner); // Make sure token owner is not sending to self\n', '        require(_addressNotNull(newOwner)); //Safety check to prevent against an unexpected 0x0 default.\n', '\n', '\t    uint256 oldSoldPrice = worldCupIdToPrice[_tokenId];//worldCupIdToOldPrice[_tokenId];\n', '\t    uint256 diffPrice = SafeMath.sub(msg.value, oldSoldPrice);\n', '\t    uint256 priceOfOldOwner = SafeMath.add(oldSoldPrice, SafeMath.div(diffPrice, 2));\n', '\t    uint256 priceOfDevelop = SafeMath.div(diffPrice, 4);\n', '\t    worldCupIdToPrice[_tokenId] = msg.value;//SafeMath.add(msg.value, SafeMath.div(msg.value, 10));\n', '\t    //worldCupIdToOldPrice[_tokenId] = msg.value;\n', '\n', '        _transfer(oldOwner, newOwner, _tokenId);\n', '        if (oldOwner != address(this)) {\n', '\t        oldOwner.transfer(priceOfOldOwner);\n', '        }\n', '\t    ceoAddress.transfer(priceOfDevelop);\n', '\t    if(this.balance >= uint256(3.2 ether)){\n', '            if((uint256(now) - SHARE_BONUS_TIME) >= 86400){\n', '\t\t        for(uint256 i=0; i<32; i++){\n', '\t\t            worldCupIdToOwnerAddress[i].transfer(0.1 ether);\n', '\t\t\t\t\tShareBonus(worldCupIdToOwnerAddress[i], i, uint256(now), this.balance);\n', '\t\t        }\n', '\t\t\t    SHARE_BONUS_TIME = uint256(now);\n', '\t\t\t    //ShareBonus(SHARE_BONUS_TIME, this.balance);\n', '\t\t    }\n', '\t    }\n', '\t    WorldCupTokenWereSold(newOwner, _tokenId, oldSoldPrice, msg.value, oldOwner, uint256(now));\n', '\t}\n', '\n', '    function priceOf(uint256 _tokenId) public view returns (uint256 price) {\n', '        return worldCupIdToPrice[_tokenId];\n', '    }\n', '\n', '    /// @dev Required for ERC-721 compliance.\n', '    function takeOwnership(uint256 _tokenId) public {\n', '        address newOwner = msg.sender;\n', '        address oldOwner = worldCupIdToOwnerAddress[_tokenId];\n', '\n', '        // Safety check to prevent against an unexpected 0x0 default.\n', '        require(_addressNotNull(newOwner));\n', '\n', '        // Making sure transfer is approved\n', '        require(_approved(newOwner, _tokenId));\n', '\n', '        _transfer(oldOwner, newOwner, _tokenId);\n', '    }\n', '\n', '    function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {\n', '        uint256 tokenCount = balanceOf(_owner);\n', '        if (tokenCount == 0) {\n', '            return new uint256[](0);\n', '        } else {\n', '            uint256[] memory result = new uint256[](tokenCount);\n', '            uint256 totalCars = totalSupply();\n', '            uint256 resultIndex = 0;\n', '\n', '            uint256 carId;\n', '            for (carId = 0; carId <= totalCars; carId++) {\n', '                if (worldCupIdToOwnerAddress[carId] == _owner) {\n', '                    result[resultIndex] = carId;\n', '                    resultIndex++;\n', '                }\n', '            }\n', '            return result;\n', '        }\n', '    }\n', '  \n', '    function getCEO() public view returns (address ceoAddr) {\n', '        return ceoAddress;\n', '    }\n', '\n', '    //Required for ERC-721 compliance.\n', '    function totalSupply() public view returns (uint256 total) {\n', '        return worldCupTeamDescribe.length;\n', '    }\n', '  \n', '    //return BonusPool $\n', '    function getBonusPool() public view returns (uint256) {\n', '        return this.balance;\n', '    }\n', '  \n', '    function getTimeFromPrize() public view returns (uint256) {\n', '        return uint256(now) - SHARE_BONUS_TIME;\n', '    }\n', '\n', '    /// @dev Required for ERC-721 compliance.\n', '    function transfer(address _to, uint256 _tokenId) public {\n', '        require(_isOwner(msg.sender, _tokenId));\n', '        require(_addressNotNull(_to));\n', '\n', '        _transfer(msg.sender, _to, _tokenId);\n', '    }\n', '\n', '    /// @dev Required for ERC-721 compliance.\n', '    function transferFrom(address _from, address _to, uint256 _tokenId) public {\n', '        require(_isOwner(_from, _tokenId));\n', '        require(_approved(_to, _tokenId));\n', '        require(_addressNotNull(_to));\n', '\n', '        _transfer(_from, _to, _tokenId);\n', '    }\n', '\n', '    /********----------- PRIVATE FUNCTIONS ------------********/\n', '    function _addressNotNull(address _to) private pure returns (bool) {\n', '        return _to != address(0);\n', '    }\n', '\n', '    function _approved(address _to, uint256 _tokenId) private view returns (bool) {\n', '        return worldCupIdToAddressForApproved[_tokenId] == _to;\n', '    }\n', '\n', '    function _isOwner(address checkAddress, uint256 _tokenId) private view returns (bool) {\n', '        return checkAddress == worldCupIdToOwnerAddress[_tokenId];\n', '    }\n', '\n', '    function _transfer(address _from, address _to, uint256 _tokenId) private {\n', '        ownerAddressToTokenCount[_to]++;\n', '        worldCupIdToOwnerAddress[_tokenId] = _to;  //transfer ownership\n', '\n', '        if (_from != address(0)) {\n', '            ownerAddressToTokenCount[_from]--;\n', '            delete worldCupIdToAddressForApproved[_tokenId];\n', '        }\n', '        Transfer(_from, _to, _tokenId);\n', '    }\n', '}']