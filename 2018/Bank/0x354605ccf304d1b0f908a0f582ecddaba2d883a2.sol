['library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c>= a);\n', '        return c;\n', '    }\n', '}\n', 'contract ERC721 {\n', '    function approve( address _to, uint256 _tokenId) public;\n', '    function balanceOf(address _owner) public view returns (uint256 balance);\n', '    function implementsERC721() public pure returns (bool);\n', '    function ownerOf(uint256 _tokenId) public view returns (address addr);\n', '    function takeOwnership(uint256 _tokenId) public;\n', '    function totalSupply() public view returns (uint256 supply);\n', '    function transferFrom(address _from, address _to, uint256 _tokenId) public;\n', '    function transfer(address _to, uint256 _tokenId) public;\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 tokenId);\n', '    event Approval(address indexed owner, address indexed approved, uint256 tokenId);\n', '}\n', '\n', 'contract AthleteToken is ERC721 {\n', '    string public constant NAME = "CryptoFantasy";\n', '    string public constant SYMBOL = "Athlete";\n', '    uint256 private constant initPrice = 0.001 ether;\n', '    event Birth(uint256 tokenId, address owner);\n', '    event TokenSold(uint256 tokenId, uint256 sellPrice, address sellOwner, address buyOwner, string athleteId);\n', '    event Transfer(address from, address to, uint256 tokenId);\n', '    mapping (uint256 => address) public athleteIndexToOwner;\n', '\n', '    mapping (address => uint256) private ownershipTokenCount;\n', '\n', '    \n', '    mapping (uint256 => address) public athleteIndexToApproved;\n', '    mapping (uint256 => uint256) private athleteIndexToPrice;\n', '    mapping (uint256 => uint256) private athleteIndexToActualFee;\n', '    mapping (uint256 => uint256) private athleteIndexToSiteFee;\n', '    mapping (uint256 => address) private athleteIndexToActualWalletId;\n', '    mapping (uint256 => string) private athleteIndexToAthleteID;\n', '    mapping (uint256 => bool) private athleteIndexToAthleteVerificationState;\n', '    address public ceoAddress;\n', '    address public cooAddress;\n', '    uint256 public promoCreatedCount;\n', '\n', '    struct Athlete {\n', '        string  athleteId;\n', '        address actualAddress;\n', '        uint256 actualFee;\n', '        uint256 siteFee;\n', '        uint256 sellPrice;\n', '        bool    isVerified;\n', '    }\n', '    Athlete[] private athletes;\n', '    mapping (uint256 => Athlete) private athleteIndexToAthlete;\n', '    modifier onlyCEO() {\n', '        require(msg.sender == ceoAddress);\n', '        _;\n', '    }\n', '    modifier onlyCOO() {\n', '        require(msg.sender == cooAddress);\n', '        _;\n', '    }\n', '    modifier onlyCLevel() {\n', '        require(msg.sender == ceoAddress || msg.sender == cooAddress);\n', '        _;\n', '    }\n', '\n', '    function AthleteToken() public {\n', '        ceoAddress = msg.sender;\n', '        cooAddress = msg.sender;\n', '    }\n', '\n', '    function approve( address _to, uint256 _tokenId ) public {\n', '        require(_owns(msg.sender, _tokenId));\n', '        athleteIndexToApproved[_tokenId] = _to;\n', '        Approval(msg.sender, _to, _tokenId);\n', '    }\n', '\n', '    function balanceOf(address _owner) public view returns (uint256 balance) {\n', '        return ownershipTokenCount[_owner];\n', '    }\n', '\n', '    function createOfAthleteCard(string _athleteId, address _actualAddress, uint256 _actualFee, uint256 _siteFee, uint256 _sellPrice) public onlyCOO returns (uint256 _newAthleteId) {\n', '        \n', '        address _athleteOwner = address(this);\n', '        bool _verified = true;\n', '        if ( _sellPrice <= 0 ) {\n', '            _sellPrice = initPrice;\n', '        }\n', '        if ( _actualAddress == address(0) ){\n', '            _actualAddress = ceoAddress;\n', '            _verified = false;\n', '        }\n', '        \n', '        Athlete memory _athlete = Athlete({ athleteId: _athleteId, actualAddress: _actualAddress, actualFee: _actualFee,  siteFee: _siteFee, sellPrice: _sellPrice, isVerified: _verified });\n', '        uint256 newAthleteId = athletes.push(_athlete) - 1;\n', '        \n', '        require(newAthleteId == uint256(uint32(newAthleteId)));\n', '        Birth(newAthleteId, _athleteOwner);\n', '        \n', '        athleteIndexToPrice[newAthleteId] = _sellPrice;\n', '        athleteIndexToActualFee[newAthleteId] = _actualFee;\n', '        athleteIndexToSiteFee[newAthleteId] = _siteFee;\n', '        athleteIndexToActualWalletId[newAthleteId] = _actualAddress;\n', '        athleteIndexToAthleteID[newAthleteId] = _athleteId;\n', '        athleteIndexToAthlete[newAthleteId] = _athlete;\n', '        athleteIndexToAthleteVerificationState[newAthleteId] = _verified;\n', '        \n', '        _transfer(address(0), _athleteOwner, newAthleteId);\n', '        return newAthleteId;\n', '    }\n', '    \n', '    function changeOriginWalletIdForAthlete( uint256 _tokenId, address _oringinWalletId ) public onlyCOO returns( string athleteId, address actualAddress, uint256 actualFee, uint256 siteFee, uint256 sellPrice, address owner) {\n', '        athleteIndexToActualWalletId[_tokenId] = _oringinWalletId;\n', '        Athlete storage athlete = athletes[_tokenId];\n', '        athlete.actualAddress = _oringinWalletId;\n', '        athleteId     = athlete.athleteId;\n', '        actualAddress = athlete.actualAddress;\n', '        actualFee     = athlete.actualFee;\n', '        siteFee       = athlete.siteFee;\n', '        sellPrice     = priceOf(_tokenId);\n', '        owner         = ownerOf(_tokenId);\n', '    }\n', '    \n', '    function changeSellPriceForAthlete( uint256 _tokenId, uint256 _newSellPrice ) public onlyCOO returns( string athleteId, address actualAddress, uint256 actualFee, uint256 siteFee, uint256 sellPrice, address owner) {\n', '        athleteIndexToPrice[_tokenId] = _newSellPrice;\n', '        Athlete storage athlete = athletes[_tokenId];\n', '        athlete.sellPrice = _newSellPrice;\n', '        athleteId     = athlete.athleteId;\n', '        actualAddress = athlete.actualAddress;\n', '        actualFee     = athlete.actualFee;\n', '        siteFee       = athlete.siteFee;\n', '        sellPrice     = athlete.sellPrice;\n', '        owner         = ownerOf(_tokenId);\n', '    }\n', '    \n', '    function createContractOfAthlete(string _athleteId, address _actualAddress, uint256 _actualFee, uint256 _siteFee, uint256 _sellPrice) public onlyCOO{\n', '        _createOfAthlete(address(this), _athleteId, _actualAddress, _actualFee, _siteFee, _sellPrice);\n', '    }\n', '\n', '    function getAthlete(uint256 _tokenId) public view returns ( string athleteId, address actualAddress, uint256 actualFee, uint256 siteFee, uint256 sellPrice, address owner) {\n', '        Athlete storage athlete = athletes[_tokenId];\n', '        athleteId     = athlete.athleteId;\n', '        actualAddress = athlete.actualAddress;\n', '        actualFee     = athlete.actualFee;\n', '        siteFee       = athlete.siteFee;\n', '        sellPrice     = priceOf(_tokenId);\n', '        owner         = ownerOf(_tokenId);\n', '    }\n', '\n', '    function implementsERC721() public pure returns (bool) {\n', '        return true;\n', '    }\n', '    function name() public pure returns (string) {\n', '        return NAME;\n', '    }\n', '    function ownerOf(uint256 _tokenId) public view returns (address owner) {\n', '        owner = athleteIndexToOwner[_tokenId];\n', '        require(owner != address(0));\n', '    }\n', '    function payout(address _to) public onlyCLevel {\n', '        _payout(_to);\n', '    }\n', '    function purchase(uint256 _tokenId) public payable {\n', '        address sellOwner = athleteIndexToOwner[_tokenId];\n', '        address buyOwner = msg.sender;\n', '        uint256 sellPrice = msg.value;\n', '\n', '        //make sure token owner is not sending to self\n', '        require(sellOwner != buyOwner);\n', '        //safely check to prevent against an unexpected 0x0 default\n', '        require(_addressNotNull(buyOwner));\n', '        //make sure sent amount is greater than or equal to the sellPrice\n', '        require(msg.value >= sellPrice);\n', '        uint256 actualFee = uint256(SafeMath.div(SafeMath.mul(sellPrice, athleteIndexToActualFee[_tokenId]), 100)); // calculate actual fee\n', '        uint256 siteFee   = uint256(SafeMath.div(SafeMath.mul(sellPrice, athleteIndexToSiteFee[_tokenId]), 100));   // calculate site fee\n', '        uint256 payment   = uint256(SafeMath.sub(sellPrice, SafeMath.add(actualFee, siteFee)));   //payment for seller\n', '\n', '        _transfer(sellOwner, buyOwner, _tokenId);\n', '        //Pay previous tokenOwner if owner is not contract\n', '        if ( sellOwner != address(this) ) {\n', '            sellOwner.transfer(payment); // (1-(actual_fee+site_fee))*sellPrice\n', '        }\n', '        TokenSold(_tokenId, sellPrice, sellOwner, buyOwner, athletes[_tokenId].athleteId);\n', '        address actualWallet = athleteIndexToActualWalletId[_tokenId];\n', '        actualWallet.transfer(actualFee);\n', '            \n', '        ceoAddress.transfer(siteFee);\n', '\n', '    }\n', '\n', '    function priceOf(uint256 _tokenId) public view returns (uint256 price) {\n', '        return athleteIndexToPrice[_tokenId];\n', '    }\n', '    function setCEO(address _newCEO) public onlyCEO {\n', '        require(_newCEO != address(0));\n', '        ceoAddress = _newCEO;\n', '    }\n', '    function setCOO(address _newCOO) public onlyCEO {\n', '        require(_newCOO != address(0));\n', '        cooAddress = _newCOO;\n', '    }\n', '    function symbol() public pure returns (string) {\n', '        return SYMBOL;\n', '    }\n', '    function takeOwnership(uint256 _tokenId) public {\n', '        address newOwner = msg.sender;\n', '        address oldOwner = athleteIndexToOwner[_tokenId];\n', '        \n', '        require(_addressNotNull(newOwner));\n', '        require(_approved(newOwner, _tokenId));\n', '        _transfer(oldOwner, newOwner, _tokenId);\n', '    }\n', '\n', '    function tokenOfOwner(address _owner) public view returns(uint256[] ownerTokens) {\n', '        uint256 tokenCount = balanceOf(_owner);\n', '        if ( tokenCount == 0 ) {\n', '            return new uint256[](0);\n', '        }\n', '        else {\n', '            uint256[] memory result = new uint256[](tokenCount);\n', '            uint256 totalAthletes = totalSupply();\n', '            uint256 resultIndex = 0;\n', '            uint256 athleteId;\n', '\n', '            for(athleteId = 0; athleteId <= totalAthletes; athleteId++) {\n', '                if (athleteIndexToOwner[athleteId] == _owner) {\n', '                    result[resultIndex] = athleteId;\n', '                    resultIndex++;\n', '                }\n', '            }\n', '            return result;\n', '        }\n', '    }\n', '\n', '    function totalSupply() public view returns (uint256 total) {\n', '        return athletes.length;\n', '    }\n', '\n', '    function transfer( address _to, uint256 _tokenId ) public {\n', '        require(_owns(msg.sender, _tokenId));\n', '        require(_addressNotNull(_to));\n', '\n', '        _transfer(msg.sender, _to, _tokenId);\n', '    }\n', '\n', '    function transferFrom( address _from, address _to, uint256 _tokenId ) public {\n', '        require(_owns(_from, _tokenId));\n', '        require(_approved(_to, _tokenId));\n', '        require(_addressNotNull(_to));\n', '\n', '        _transfer(_from, _to, _tokenId);\n', '    }\n', '\n', '    function _addressNotNull(address _to) private pure returns (bool) {\n', '        return _to != address(0);\n', '    }\n', '    function _approved(address _to, uint256 _tokenId) private view returns (bool) {\n', '        return athleteIndexToApproved[_tokenId] == _to;\n', '    }\n', '\n', '    function _createOfAthlete(address _athleteOwner, string _athleteId, address _actualAddress, uint256 _actualFee, uint256 _siteFee, uint256 _sellPrice) private {\n', '        \n', '        bool _verified = true;\n', '        // Check sell price and origin wallet id\n', '        if ( _sellPrice <= 0 ) {\n', '            _sellPrice = initPrice;\n', '        }\n', '        if ( _actualAddress == address(0) ){\n', '            _actualAddress = ceoAddress;\n', '            _verified = false;\n', '        }\n', '        \n', '        Athlete memory _athlete = Athlete({ athleteId: _athleteId, actualAddress: _actualAddress, actualFee: _actualFee,  siteFee: _siteFee, sellPrice: _sellPrice, isVerified: _verified });\n', '        uint256 newAthleteId = athletes.push(_athlete) - 1;\n', '        \n', '        require(newAthleteId == uint256(uint32(newAthleteId)));\n', '        Birth(newAthleteId, _athleteOwner);\n', '        \n', '        athleteIndexToPrice[newAthleteId] = _sellPrice;\n', '        athleteIndexToActualFee[newAthleteId] = _actualFee;\n', '        athleteIndexToSiteFee[newAthleteId] = _siteFee;\n', '        athleteIndexToActualWalletId[newAthleteId] = _actualAddress;\n', '        athleteIndexToAthleteID[newAthleteId] = _athleteId;\n', '        athleteIndexToAthlete[newAthleteId] = _athlete;\n', '        athleteIndexToAthleteVerificationState[newAthleteId] = _verified;\n', '        \n', '        _transfer(address(0), _athleteOwner, newAthleteId);\n', '\n', '    }\n', '\n', '    function _owns(address claimant, uint256 _tokenId) private view returns (bool) {\n', '        return claimant == athleteIndexToOwner[_tokenId];\n', '    }\n', '    function _payout(address _to) private {\n', '        if (_to == address(0)) {\n', '            ceoAddress.transfer(this.balance);\n', '        }\n', '        else {\n', '            _to.transfer(this.balance);\n', '        }\n', '    }\n', '    function _transfer(address _from, address _to, uint256 _tokenId) private {\n', '        ownershipTokenCount[_to]++;\n', '        athleteIndexToOwner[_tokenId] = _to;\n', '        if (_from != address(0)) {\n', '            ownershipTokenCount[_from]--;\n', '            delete athleteIndexToApproved[_tokenId];\n', '        }\n', '        Transfer(_from, _to, _tokenId);\n', '    }\n', '\n', '}']
['library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c>= a);\n', '        return c;\n', '    }\n', '}\n', 'contract ERC721 {\n', '    function approve( address _to, uint256 _tokenId) public;\n', '    function balanceOf(address _owner) public view returns (uint256 balance);\n', '    function implementsERC721() public pure returns (bool);\n', '    function ownerOf(uint256 _tokenId) public view returns (address addr);\n', '    function takeOwnership(uint256 _tokenId) public;\n', '    function totalSupply() public view returns (uint256 supply);\n', '    function transferFrom(address _from, address _to, uint256 _tokenId) public;\n', '    function transfer(address _to, uint256 _tokenId) public;\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 tokenId);\n', '    event Approval(address indexed owner, address indexed approved, uint256 tokenId);\n', '}\n', '\n', 'contract AthleteToken is ERC721 {\n', '    string public constant NAME = "CryptoFantasy";\n', '    string public constant SYMBOL = "Athlete";\n', '    uint256 private constant initPrice = 0.001 ether;\n', '    event Birth(uint256 tokenId, address owner);\n', '    event TokenSold(uint256 tokenId, uint256 sellPrice, address sellOwner, address buyOwner, string athleteId);\n', '    event Transfer(address from, address to, uint256 tokenId);\n', '    mapping (uint256 => address) public athleteIndexToOwner;\n', '\n', '    mapping (address => uint256) private ownershipTokenCount;\n', '\n', '    \n', '    mapping (uint256 => address) public athleteIndexToApproved;\n', '    mapping (uint256 => uint256) private athleteIndexToPrice;\n', '    mapping (uint256 => uint256) private athleteIndexToActualFee;\n', '    mapping (uint256 => uint256) private athleteIndexToSiteFee;\n', '    mapping (uint256 => address) private athleteIndexToActualWalletId;\n', '    mapping (uint256 => string) private athleteIndexToAthleteID;\n', '    mapping (uint256 => bool) private athleteIndexToAthleteVerificationState;\n', '    address public ceoAddress;\n', '    address public cooAddress;\n', '    uint256 public promoCreatedCount;\n', '\n', '    struct Athlete {\n', '        string  athleteId;\n', '        address actualAddress;\n', '        uint256 actualFee;\n', '        uint256 siteFee;\n', '        uint256 sellPrice;\n', '        bool    isVerified;\n', '    }\n', '    Athlete[] private athletes;\n', '    mapping (uint256 => Athlete) private athleteIndexToAthlete;\n', '    modifier onlyCEO() {\n', '        require(msg.sender == ceoAddress);\n', '        _;\n', '    }\n', '    modifier onlyCOO() {\n', '        require(msg.sender == cooAddress);\n', '        _;\n', '    }\n', '    modifier onlyCLevel() {\n', '        require(msg.sender == ceoAddress || msg.sender == cooAddress);\n', '        _;\n', '    }\n', '\n', '    function AthleteToken() public {\n', '        ceoAddress = msg.sender;\n', '        cooAddress = msg.sender;\n', '    }\n', '\n', '    function approve( address _to, uint256 _tokenId ) public {\n', '        require(_owns(msg.sender, _tokenId));\n', '        athleteIndexToApproved[_tokenId] = _to;\n', '        Approval(msg.sender, _to, _tokenId);\n', '    }\n', '\n', '    function balanceOf(address _owner) public view returns (uint256 balance) {\n', '        return ownershipTokenCount[_owner];\n', '    }\n', '\n', '    function createOfAthleteCard(string _athleteId, address _actualAddress, uint256 _actualFee, uint256 _siteFee, uint256 _sellPrice) public onlyCOO returns (uint256 _newAthleteId) {\n', '        \n', '        address _athleteOwner = address(this);\n', '        bool _verified = true;\n', '        if ( _sellPrice <= 0 ) {\n', '            _sellPrice = initPrice;\n', '        }\n', '        if ( _actualAddress == address(0) ){\n', '            _actualAddress = ceoAddress;\n', '            _verified = false;\n', '        }\n', '        \n', '        Athlete memory _athlete = Athlete({ athleteId: _athleteId, actualAddress: _actualAddress, actualFee: _actualFee,  siteFee: _siteFee, sellPrice: _sellPrice, isVerified: _verified });\n', '        uint256 newAthleteId = athletes.push(_athlete) - 1;\n', '        \n', '        require(newAthleteId == uint256(uint32(newAthleteId)));\n', '        Birth(newAthleteId, _athleteOwner);\n', '        \n', '        athleteIndexToPrice[newAthleteId] = _sellPrice;\n', '        athleteIndexToActualFee[newAthleteId] = _actualFee;\n', '        athleteIndexToSiteFee[newAthleteId] = _siteFee;\n', '        athleteIndexToActualWalletId[newAthleteId] = _actualAddress;\n', '        athleteIndexToAthleteID[newAthleteId] = _athleteId;\n', '        athleteIndexToAthlete[newAthleteId] = _athlete;\n', '        athleteIndexToAthleteVerificationState[newAthleteId] = _verified;\n', '        \n', '        _transfer(address(0), _athleteOwner, newAthleteId);\n', '        return newAthleteId;\n', '    }\n', '    \n', '    function changeOriginWalletIdForAthlete( uint256 _tokenId, address _oringinWalletId ) public onlyCOO returns( string athleteId, address actualAddress, uint256 actualFee, uint256 siteFee, uint256 sellPrice, address owner) {\n', '        athleteIndexToActualWalletId[_tokenId] = _oringinWalletId;\n', '        Athlete storage athlete = athletes[_tokenId];\n', '        athlete.actualAddress = _oringinWalletId;\n', '        athleteId     = athlete.athleteId;\n', '        actualAddress = athlete.actualAddress;\n', '        actualFee     = athlete.actualFee;\n', '        siteFee       = athlete.siteFee;\n', '        sellPrice     = priceOf(_tokenId);\n', '        owner         = ownerOf(_tokenId);\n', '    }\n', '    \n', '    function changeSellPriceForAthlete( uint256 _tokenId, uint256 _newSellPrice ) public onlyCOO returns( string athleteId, address actualAddress, uint256 actualFee, uint256 siteFee, uint256 sellPrice, address owner) {\n', '        athleteIndexToPrice[_tokenId] = _newSellPrice;\n', '        Athlete storage athlete = athletes[_tokenId];\n', '        athlete.sellPrice = _newSellPrice;\n', '        athleteId     = athlete.athleteId;\n', '        actualAddress = athlete.actualAddress;\n', '        actualFee     = athlete.actualFee;\n', '        siteFee       = athlete.siteFee;\n', '        sellPrice     = athlete.sellPrice;\n', '        owner         = ownerOf(_tokenId);\n', '    }\n', '    \n', '    function createContractOfAthlete(string _athleteId, address _actualAddress, uint256 _actualFee, uint256 _siteFee, uint256 _sellPrice) public onlyCOO{\n', '        _createOfAthlete(address(this), _athleteId, _actualAddress, _actualFee, _siteFee, _sellPrice);\n', '    }\n', '\n', '    function getAthlete(uint256 _tokenId) public view returns ( string athleteId, address actualAddress, uint256 actualFee, uint256 siteFee, uint256 sellPrice, address owner) {\n', '        Athlete storage athlete = athletes[_tokenId];\n', '        athleteId     = athlete.athleteId;\n', '        actualAddress = athlete.actualAddress;\n', '        actualFee     = athlete.actualFee;\n', '        siteFee       = athlete.siteFee;\n', '        sellPrice     = priceOf(_tokenId);\n', '        owner         = ownerOf(_tokenId);\n', '    }\n', '\n', '    function implementsERC721() public pure returns (bool) {\n', '        return true;\n', '    }\n', '    function name() public pure returns (string) {\n', '        return NAME;\n', '    }\n', '    function ownerOf(uint256 _tokenId) public view returns (address owner) {\n', '        owner = athleteIndexToOwner[_tokenId];\n', '        require(owner != address(0));\n', '    }\n', '    function payout(address _to) public onlyCLevel {\n', '        _payout(_to);\n', '    }\n', '    function purchase(uint256 _tokenId) public payable {\n', '        address sellOwner = athleteIndexToOwner[_tokenId];\n', '        address buyOwner = msg.sender;\n', '        uint256 sellPrice = msg.value;\n', '\n', '        //make sure token owner is not sending to self\n', '        require(sellOwner != buyOwner);\n', '        //safely check to prevent against an unexpected 0x0 default\n', '        require(_addressNotNull(buyOwner));\n', '        //make sure sent amount is greater than or equal to the sellPrice\n', '        require(msg.value >= sellPrice);\n', '        uint256 actualFee = uint256(SafeMath.div(SafeMath.mul(sellPrice, athleteIndexToActualFee[_tokenId]), 100)); // calculate actual fee\n', '        uint256 siteFee   = uint256(SafeMath.div(SafeMath.mul(sellPrice, athleteIndexToSiteFee[_tokenId]), 100));   // calculate site fee\n', '        uint256 payment   = uint256(SafeMath.sub(sellPrice, SafeMath.add(actualFee, siteFee)));   //payment for seller\n', '\n', '        _transfer(sellOwner, buyOwner, _tokenId);\n', '        //Pay previous tokenOwner if owner is not contract\n', '        if ( sellOwner != address(this) ) {\n', '            sellOwner.transfer(payment); // (1-(actual_fee+site_fee))*sellPrice\n', '        }\n', '        TokenSold(_tokenId, sellPrice, sellOwner, buyOwner, athletes[_tokenId].athleteId);\n', '        address actualWallet = athleteIndexToActualWalletId[_tokenId];\n', '        actualWallet.transfer(actualFee);\n', '            \n', '        ceoAddress.transfer(siteFee);\n', '\n', '    }\n', '\n', '    function priceOf(uint256 _tokenId) public view returns (uint256 price) {\n', '        return athleteIndexToPrice[_tokenId];\n', '    }\n', '    function setCEO(address _newCEO) public onlyCEO {\n', '        require(_newCEO != address(0));\n', '        ceoAddress = _newCEO;\n', '    }\n', '    function setCOO(address _newCOO) public onlyCEO {\n', '        require(_newCOO != address(0));\n', '        cooAddress = _newCOO;\n', '    }\n', '    function symbol() public pure returns (string) {\n', '        return SYMBOL;\n', '    }\n', '    function takeOwnership(uint256 _tokenId) public {\n', '        address newOwner = msg.sender;\n', '        address oldOwner = athleteIndexToOwner[_tokenId];\n', '        \n', '        require(_addressNotNull(newOwner));\n', '        require(_approved(newOwner, _tokenId));\n', '        _transfer(oldOwner, newOwner, _tokenId);\n', '    }\n', '\n', '    function tokenOfOwner(address _owner) public view returns(uint256[] ownerTokens) {\n', '        uint256 tokenCount = balanceOf(_owner);\n', '        if ( tokenCount == 0 ) {\n', '            return new uint256[](0);\n', '        }\n', '        else {\n', '            uint256[] memory result = new uint256[](tokenCount);\n', '            uint256 totalAthletes = totalSupply();\n', '            uint256 resultIndex = 0;\n', '            uint256 athleteId;\n', '\n', '            for(athleteId = 0; athleteId <= totalAthletes; athleteId++) {\n', '                if (athleteIndexToOwner[athleteId] == _owner) {\n', '                    result[resultIndex] = athleteId;\n', '                    resultIndex++;\n', '                }\n', '            }\n', '            return result;\n', '        }\n', '    }\n', '\n', '    function totalSupply() public view returns (uint256 total) {\n', '        return athletes.length;\n', '    }\n', '\n', '    function transfer( address _to, uint256 _tokenId ) public {\n', '        require(_owns(msg.sender, _tokenId));\n', '        require(_addressNotNull(_to));\n', '\n', '        _transfer(msg.sender, _to, _tokenId);\n', '    }\n', '\n', '    function transferFrom( address _from, address _to, uint256 _tokenId ) public {\n', '        require(_owns(_from, _tokenId));\n', '        require(_approved(_to, _tokenId));\n', '        require(_addressNotNull(_to));\n', '\n', '        _transfer(_from, _to, _tokenId);\n', '    }\n', '\n', '    function _addressNotNull(address _to) private pure returns (bool) {\n', '        return _to != address(0);\n', '    }\n', '    function _approved(address _to, uint256 _tokenId) private view returns (bool) {\n', '        return athleteIndexToApproved[_tokenId] == _to;\n', '    }\n', '\n', '    function _createOfAthlete(address _athleteOwner, string _athleteId, address _actualAddress, uint256 _actualFee, uint256 _siteFee, uint256 _sellPrice) private {\n', '        \n', '        bool _verified = true;\n', '        // Check sell price and origin wallet id\n', '        if ( _sellPrice <= 0 ) {\n', '            _sellPrice = initPrice;\n', '        }\n', '        if ( _actualAddress == address(0) ){\n', '            _actualAddress = ceoAddress;\n', '            _verified = false;\n', '        }\n', '        \n', '        Athlete memory _athlete = Athlete({ athleteId: _athleteId, actualAddress: _actualAddress, actualFee: _actualFee,  siteFee: _siteFee, sellPrice: _sellPrice, isVerified: _verified });\n', '        uint256 newAthleteId = athletes.push(_athlete) - 1;\n', '        \n', '        require(newAthleteId == uint256(uint32(newAthleteId)));\n', '        Birth(newAthleteId, _athleteOwner);\n', '        \n', '        athleteIndexToPrice[newAthleteId] = _sellPrice;\n', '        athleteIndexToActualFee[newAthleteId] = _actualFee;\n', '        athleteIndexToSiteFee[newAthleteId] = _siteFee;\n', '        athleteIndexToActualWalletId[newAthleteId] = _actualAddress;\n', '        athleteIndexToAthleteID[newAthleteId] = _athleteId;\n', '        athleteIndexToAthlete[newAthleteId] = _athlete;\n', '        athleteIndexToAthleteVerificationState[newAthleteId] = _verified;\n', '        \n', '        _transfer(address(0), _athleteOwner, newAthleteId);\n', '\n', '    }\n', '\n', '    function _owns(address claimant, uint256 _tokenId) private view returns (bool) {\n', '        return claimant == athleteIndexToOwner[_tokenId];\n', '    }\n', '    function _payout(address _to) private {\n', '        if (_to == address(0)) {\n', '            ceoAddress.transfer(this.balance);\n', '        }\n', '        else {\n', '            _to.transfer(this.balance);\n', '        }\n', '    }\n', '    function _transfer(address _from, address _to, uint256 _tokenId) private {\n', '        ownershipTokenCount[_to]++;\n', '        athleteIndexToOwner[_tokenId] = _to;\n', '        if (_from != address(0)) {\n', '            ownershipTokenCount[_from]--;\n', '            delete athleteIndexToApproved[_tokenId];\n', '        }\n', '        Transfer(_from, _to, _tokenId);\n', '    }\n', '\n', '}']