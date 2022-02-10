['pragma solidity ^0.4.17;\n', '//**\n', '//**\n', 'contract ERC721 {\n', '   // ERC20 compatible functions\n', '  string public name = "CryptoElections";\n', '  string public symbol = "CE";\n', '   function totalSupply()  public view returns (uint256);\n', '   function balanceOf(address _owner) public constant returns (uint);\n', '   // Functions that define ownership\n', '   function ownerOf(uint256 _tokenId) public constant returns (address owner);\n', '   function approve(address _to, uint256 _tokenId) public returns (bool success);\n', '   function takeOwnership(uint256 _tokenId) public;\n', '   function transfer(address _to, uint256 _tokenId) public returns (bool success);\n', '  function transferFrom(address _from, address _to, uint _tokenId) public returns (bool success);\n', '   function tokensOfOwnerByIndex(address _owner, uint256 _index) view public  returns (uint tokenId);\n', '   // Token metadata\n', ' // function tokenMetadata(uint256 _tokenId) constant returns (string infoUrl);\n', ' function implementsERC721() public pure returns (bool);\n', '}\n', '\n', 'contract CryptoElections is ERC721 {\n', '\n', '    /* Define variable owner of the type address */\n', '    address creator;\n', '\n', '    modifier onlyCreator() {\n', '        require(msg.sender == creator);\n', '        _;\n', '    }\n', '\n', '    modifier onlyCountryOwner(uint256 countryId) {\n', '        require(countries[countryId].president==msg.sender);\n', '        _;\n', '    }\n', '    modifier onlyCityOwner(uint cityId) {\n', '        require(cities[cityId].mayor==msg.sender);\n', '        _;\n', '    }\n', '\n', '    struct Country {\n', '        address president;\n', '        string slogan;\n', '        string flagUrl;\n', '    }\n', '    struct City {\n', '        address mayor;\n', '        string slogan;\n', '        string picture;\n', '        uint purchases;\n', '        uint startPrice;\n', '          uint multiplierStep;\n', '    }\n', '    \n', '    \n', '    \n', '    bool maintenance=false;\n', '    bool transferEnabled=false;\n', '    bool inited=false;\n', '    event withdrawalEvent(address user,uint value);\n', '    event pendingWithdrawalEvent(address user,uint value);\n', '    event assignCountryEvent(address user,uint countryId);\n', '    event buyCityEvent(address user,uint cityId);\n', '    \n', '       // Events\n', '   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);\n', '   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);\n', '   \n', '   \n', '    mapping(uint => Country) public countries ;\n', '    mapping(uint =>  uint[]) public countriesCities ;\n', '    mapping(uint =>  uint) public citiesCountries ;\n', '\n', '    mapping(uint =>  uint) public cityPopulation ;\n', '    mapping(uint => City) public cities;\n', '    mapping(address => uint[]) public userCities;\n', '    mapping(address => uint) public userPendingWithdrawals;\n', '    mapping(address => string) public userNicknames;\n', '     mapping(bytes32 => bool) public takenNicknames;\n', '    mapping(address => mapping (address => uint256)) private allowed;\n', '       \n', '    uint totalCities=0;\n', '\n', ' function implementsERC721() public pure returns (bool)\n', '    {\n', '        return true;\n', '    }\n', '\n', '\n', '\n', '    // ------------------------------------------------------------------------\n', '    // Returns alloed status\n', '    // ------------------------------------------------------------------------\n', '    function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {\n', '        require(transferEnabled);\n', '        return allowed[tokenOwner][spender];\n', '    }\n', '\n', '   function totalSupply()  public  view returns (uint256 ) {\n', '       \n', '       return totalCities;\n', '   }\n', '    function CryptoElections() public {\n', '        creator = msg.sender;\n', '    }\n', '\n', '    function () public payable {\n', '        revert();\n', '    }\n', '   \n', '    \n', '      function balanceOf(address _owner) constant public returns (uint balance) {\n', '          \n', '          return userCities[_owner].length;\n', '      }\n', '      \n', '        function ownerOf(uint256 _tokenId) constant public  returns (address owner) {\n', '            \n', '            return cities[_tokenId].mayor;\n', '        }\n', ' \n', ' \n', '       function approve(address _to, uint256 _tokenId) public returns (bool success){\n', '           require(transferEnabled);\n', '       require(msg.sender == ownerOf(_tokenId));\n', '       require(msg.sender != _to);\n', '       allowed[msg.sender][_to] = _tokenId;\n', '       Approval(msg.sender, _to, _tokenId);\n', '       return true;\n', '   }\n', '   \n', '     function takeOwnership(uint256 _tokenId) public {\n', '         require(transferEnabled);\n', '       require(cityPopulation[_tokenId]!=0);\n', '       address oldOwner = ownerOf(_tokenId);\n', '       address newOwner = msg.sender;\n', '       require(newOwner != oldOwner);\n', '       // cities can be transfered one-by-one\n', '       require(allowed[oldOwner][newOwner] == _tokenId);\n', '       \n', '       \n', '       _removeUserCity(oldOwner,_tokenId);\n', '       cities[_tokenId].mayor=newOwner;\n', '       _addUserCity(newOwner,_tokenId);\n', '       \n', '   \n', '       Transfer(oldOwner, newOwner, _tokenId);\n', '   }\n', '   \n', '\n', '      function transfer(address _to, uint256 _tokenId) public  returns (bool success) {\n', '       require(transferEnabled);\n', '       address currentOwner = msg.sender;\n', '       address newOwner = _to;\n', '      \n', '        require(cityPopulation[_tokenId]!=0);\n', '       require(currentOwner == ownerOf(_tokenId));\n', '       require(currentOwner != newOwner);\n', '       require(newOwner != address(0));\n', '        _removeUserCity(currentOwner,_tokenId);\n', '       cities[_tokenId].mayor=newOwner;\n', '   \n', '        _addUserCity(newOwner,_tokenId);\n', '       Transfer(currentOwner, newOwner, _tokenId);\n', '       return true;\n', '   }\n', '   \n', '     function transferFrom(address from, address to, uint _tokenId) public returns (bool success) {\n', '         \n', '           require(transferEnabled);\n', '       address currentOwner = from;\n', '       address newOwner = to;\n', '      \n', '        require(cityPopulation[_tokenId]!=0);\n', '       require(currentOwner == ownerOf(_tokenId));\n', '       require(currentOwner != newOwner);\n', '       require(newOwner != address(0));\n', '         // cities can be transfered one-by-one\n', '       require(allowed[currentOwner][msg.sender] == _tokenId);\n', '       \n', '        _removeUserCity(currentOwner,_tokenId);\n', '       cities[_tokenId].mayor=newOwner;\n', '   \n', '        _addUserCity(newOwner,_tokenId);\n', '       Transfer(currentOwner, newOwner, _tokenId);\n', '       \n', '         return true;\n', '         \n', '     }\n', '   \n', '   \n', '    function tokensOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint tokenId) {\n', '       \n', '        return userCities[_owner][_index];\n', '    }\n', '   // Token metadata\n', '\n', '\n', '  \n', '    function markContractAsInited() public\n', '    onlyCreator() \n', '    {\n', '     inited=true;   \n', '    }\n', '    \n', '    \n', ' /*\n', '    Functions to migrate from previous contract. After migration is complete this functions will be blocked\n', '    */\n', '    function addOldMayors(uint[] citiesIds,uint[] purchases,address[] mayors) public \n', '    onlyCreator()\n', '    {\n', '        require(!inited);\n', '        for (uint i = 0;i<citiesIds.length;i++) {\n', '            cities[citiesIds[i]].mayor = mayors[i];\n', '            cities[citiesIds[i]].purchases = purchases[i];\n', '        }\n', '    }\n', '    \n', '    function addOldNickname(address user,string nickname) public\n', '    onlyCreator()\n', '    {\n', '        require(!inited);\n', '           takenNicknames[keccak256(nickname)]=true;\n', '         userNicknames[user] = nickname;\n', '    }\n', '    function addOldPresidents(uint[] countriesIds,address[] presidents) public\n', '    onlyCreator()\n', '    {\n', '        require(!inited);\n', '        for (uint i = 0;i<countriesIds.length;i++) {\n', '            countries[countriesIds[i]].president = presidents[i];\n', '        }\n', '    }\n', '    \n', '      function addOldWithdrawals(address[] userIds,uint[] withdrawals) public\n', '    onlyCreator()\n', '    {\n', '        require(!inited);\n', '        for (uint i = 0;i<userIds.length;i++) {\n', '            userPendingWithdrawals[userIds[i]] = withdrawals[i];\n', '        }\n', '    }\n', '    \n', '    /* This function is executed at initialization and sets the owner of the contract */\n', '    /* Function to recover the funds on the contract */\n', '    function kill() public\n', '    onlyCreator()\n', '    {\n', '        selfdestruct(creator);\n', '    }\n', '\n', '    function transferContract(address newCreator) public\n', '    onlyCreator()\n', '    {\n', '        creator=newCreator;\n', '    }\n', '\n', '\n', '\n', '    // Contract initialisation\n', '    function addCountryCities(uint countryId,uint[] _cities,uint multiplierStep,uint startPrice)  public\n', '    onlyCreator()\n', '    {\n', '        countriesCities[countryId] = _cities;\n', '        for (uint i = 0;i<_cities.length;i++) {\n', '            Transfer(0x0,address(this),_cities[i]);\n', '            cities[_cities[i]].multiplierStep=multiplierStep;\n', '              cities[_cities[i]].startPrice=startPrice;\n', '            citiesCountries[_cities[i]] = countryId;\n', '        }\n', '        //skipping uniquality check\n', '        totalCities+=_cities.length;\n', '    }\n', '    function setMaintenanceMode(bool _maintenance) public\n', '    onlyCreator()\n', '    {\n', '        maintenance=_maintenance;\n', '    }\n', '\n', '   function setTransferMode(bool _status) public\n', '    onlyCreator()\n', '    {\n', '        transferEnabled=_status;\n', '    }\n', '    // Contract initialisation\n', '    function addCitiesPopulation(uint[] _cities,uint[]_populations)  public\n', '    onlyCreator()\n', '    {\n', '\n', '        for (uint i = 0;i<_cities.length;i++) {\n', '\n', '            cityPopulation[_cities[i]] = _populations[i];\n', '        }\n', '        \n', '    }\n', '\n', '    function setCountrySlogan(uint countryId,string slogan) public\n', '    onlyCountryOwner(countryId)\n', '    {\n', '        countries[countryId].slogan = slogan;\n', '    }\n', '\n', '    function setCountryPicture(uint countryId,string _flagUrl) public\n', '    onlyCountryOwner(countryId)\n', '    {\n', '        countries[countryId].flagUrl = _flagUrl;\n', '    }\n', '\n', '    function setCitySlogan(uint256 cityId,string _slogan) public\n', '    onlyCityOwner(cityId)\n', '    {\n', '        cities[cityId].slogan = _slogan;\n', '    }\n', '\n', '    function setCityPicture(uint256 cityId,string _picture) public\n', '    onlyCityOwner(cityId)\n', '    {\n', '        cities[cityId].picture = _picture;\n', '    }\n', '\n', 'function stringToBytes32(string memory source) private pure returns (bytes32 result) {\n', '    bytes memory tempEmptyStringTest = bytes(source);\n', '    if (tempEmptyStringTest.length == 0) {\n', '        return 0x0;\n', '    }\n', '\n', '    assembly {\n', '        result := mload(add(source, 32))\n', '    }\n', '}\n', '    // returns address mayor;\n', '        \n', '      function getCities(uint[] citiesIds)  public view returns (City[]) {\n', '     \n', '        City[] memory cityArray= new City[](citiesIds.length);\n', '     \n', '        for (uint i=0;i<citiesIds.length;i++) {\n', '          \n', '            cityArray[i]=cities[citiesIds[i]];\n', '          \n', '            \n', '        }\n', '        return cityArray;\n', '        \n', '    }\n', '    \n', '              function getCitiesStrings(uint[] citiesIds)  public view returns (  bytes32[],bytes32[]) {\n', '     \n', '        bytes32 [] memory slogans=new bytes32[](citiesIds.length);\n', '         bytes32 [] memory pictures=new bytes32[](citiesIds.length);\n', '   \n', '     \n', '        for (uint i=0;i<citiesIds.length;i++) {\n', '          \n', '            slogans[i]=stringToBytes32(cities[citiesIds[i]].slogan);\n', '            pictures[i]=stringToBytes32(cities[citiesIds[i]].picture);\n', '       \n', '            \n', '        }\n', '        return (slogans,pictures);\n', '        \n', '    }\n', '    \n', '   \n', '    function getCitiesData(uint[] citiesIds)  public view returns (  address [],uint[],uint[],uint[]) {\n', '   \n', '         address [] memory mayors=new address[](citiesIds.length);\n', '   \n', '        uint [] memory purchases=new uint[](citiesIds.length);\n', '        uint [] memory startPrices=new uint[](citiesIds.length);\n', '        uint [] memory multiplierSteps=new uint[](citiesIds.length);\n', '                                    \n', '        for (uint i=0;i<citiesIds.length;i++) {\n', '            mayors[i]=(cities[citiesIds[i]].mayor);\n', '      \n', '            purchases[i]=(cities[citiesIds[i]].purchases);\n', '            startPrices[i]=(cities[citiesIds[i]].startPrice);\n', '            multiplierSteps[i]=(cities[citiesIds[i]].multiplierStep);\n', '            \n', '        }\n', '        return (mayors,purchases,startPrices,multiplierSteps);\n', '        \n', '    }\n', '    \n', '    function getCountriesData(uint[] countriesIds)  public view returns (    address [],bytes32[],bytes32[]) {\n', '          address [] memory presidents=new address[](countriesIds.length);\n', '        bytes32 [] memory slogans=new bytes32[](countriesIds.length);\n', '         bytes32 [] memory flagUrls=new bytes32[](countriesIds.length);\n', '   \n', '        for (uint i=0;i<countriesIds.length;i++) {\n', '            presidents[i]=(countries[countriesIds[i]].president);\n', '            slogans[i]=stringToBytes32(countries[countriesIds[i]].slogan);\n', '            flagUrls[i]=stringToBytes32(countries[countriesIds[i]].flagUrl);\n', '            \n', '        }\n', '        return (presidents,slogans,flagUrls);\n', '        \n', '    }\n', '\n', '    function withdraw() public {\n', '        if (maintenance) revert();\n', '        uint amount = userPendingWithdrawals[msg.sender];\n', '        // Remember to zero the pending refund before\n', '        // sending to prevent re-entrancy attacks\n', '\n', '        userPendingWithdrawals[msg.sender] = 0;\n', '        withdrawalEvent(msg.sender,amount);\n', '        msg.sender.transfer(amount);\n', '    }\n', '  \n', '  function getPrices2(uint purchases,uint startPrice,uint multiplierStep) public pure returns (uint[4]) {\n', '      \n', '        uint price=startPrice;\n', '        uint pricePrev = price;\n', '        uint systemCommission = startPrice;\n', '        uint presidentCommission = 0;\n', '        uint ownerCommission;\n', '\n', '        for (uint i = 1;i<=purchases;i++) {\n', '            if (i<=multiplierStep)\n', '                price = price*2;\n', '            else\n', '                price = (price*12)/10;\n', '\n', '            presidentCommission = price/100;\n', '            systemCommission = (price-pricePrev)*2/10;\n', '            ownerCommission = price-presidentCommission-systemCommission;\n', '\n', '            pricePrev = price;\n', '        }\n', '        return [price,systemCommission,presidentCommission,ownerCommission];\n', '    }\n', '\n', '\n', '    function setNickname(string nickname) public returns(bool) {\n', '        if (maintenance) revert();\n', '        if (takenNicknames[keccak256(nickname)]==true) {\n', '                     return false;\n', '        }\n', '        userNicknames[msg.sender] = nickname;\n', '        takenNicknames[keccak256(nickname)]=true;\n', '        return true;\n', '    }\n', '\n', '    function _assignCountry(uint countryId)    private returns (bool) {\n', '        uint  totalPopulation;\n', '        uint  controlledPopulation;\n', '\n', '        uint  population;\n', '        for (uint i = 0;i<countriesCities[countryId].length;i++) {\n', '            population = cityPopulation[countriesCities[countryId][i]];\n', '            if (cities[countriesCities[countryId][i]].mayor==msg.sender) {\n', '                controlledPopulation += population;\n', '            }\n', '            totalPopulation += population;\n', '        }\n', '        if (controlledPopulation*2>(totalPopulation)) {\n', '            countries[countryId].president = msg.sender;\n', '            assignCountryEvent(msg.sender,countryId);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '    \n', '\n', '    function buyCity(uint cityId) payable  public  {\n', '        if (maintenance) revert();\n', '        uint[4] memory prices = getPrices2(cities[cityId].purchases,cities[cityId].startPrice,cities[cityId].multiplierStep);\n', '\n', '        if (cities[cityId].mayor==msg.sender) {\n', '            revert();\n', '        }\n', '        if (cityPopulation[cityId]==0) {\n', '            revert();\n', '        }\n', '\n', '        if ( msg.value+userPendingWithdrawals[msg.sender]>=prices[0]) {\n', '            // use user limit\n', '            userPendingWithdrawals[msg.sender] = userPendingWithdrawals[msg.sender]+msg.value-prices[0];\n', '            pendingWithdrawalEvent(msg.sender,userPendingWithdrawals[msg.sender]+msg.value-prices[0]);\n', '\n', '            cities[cityId].purchases = cities[cityId].purchases+1;\n', '\n', '            userPendingWithdrawals[cities[cityId].mayor] += prices[3];\n', '            pendingWithdrawalEvent(cities[cityId].mayor,prices[3]);\n', '\n', '            if (countries[citiesCountries[cityId]].president==0) {\n', '                userPendingWithdrawals[creator] += prices[2];\n', '                pendingWithdrawalEvent(creator,prices[2]);\n', '\n', '            } else {\n', '                userPendingWithdrawals[countries[citiesCountries[cityId]].president] += prices[2];\n', '                pendingWithdrawalEvent(countries[citiesCountries[cityId]].president,prices[2]);\n', '            }\n', '            // change mayor\n', '            address oldMayor;\n', '            oldMayor=cities[cityId].mayor;\n', '            if (cities[cityId].mayor>0) {\n', '                _removeUserCity(cities[cityId].mayor,cityId);\n', '            }\n', '\n', '\n', '\n', '            cities[cityId].mayor = msg.sender;\n', '            _addUserCity(msg.sender,cityId);\n', '\n', '            _assignCountry(citiesCountries[cityId]);\n', '\n', '            //send money to creator\n', '            creator.transfer(prices[1]);\n', '           // buyCityEvent(msg.sender,cityId);\n', '             Transfer(0x0,msg.sender,cityId);\n', '\n', '        } else {\n', '            revert();\n', '        }\n', '    }\n', '    function getUserCities(address user) public view returns (uint[]) {\n', '        return userCities[user];\n', '    }\n', '\n', '    function _addUserCity(address user,uint cityId) private {\n', '        bool added = false;\n', '        for (uint i = 0; i<userCities[user].length; i++) {\n', '            if (userCities[user][i]==0) {\n', '                userCities[user][i] = cityId;\n', '                added = true;\n', '                break;\n', '            }\n', '        }\n', '        if (!added)\n', '            userCities[user].push(cityId);\n', '    }\n', '\n', '    function _removeUserCity(address user,uint cityId) private {\n', '        for (uint i = 0; i<userCities[user].length; i++) {\n', '            if (userCities[user][i]==cityId) {\n', '                delete userCities[user][i];\n', '            }\n', '        }\n', '    }\n', '\n', '}']