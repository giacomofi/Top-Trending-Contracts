['// File: openzeppelin-solidity/contracts/ownership/Ownable.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    constructor () internal {\n', '        _owner = msg.sender;\n', '        emit OwnershipTransferred(address(0), _owner);\n', '    }\n', '\n', '    /**\n', '     * @return the address of the owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(isOwner());\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @return true if `msg.sender` is the owner of the contract.\n', '     */\n', '    function isOwner() public view returns (bool) {\n', '        return msg.sender == _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to relinquish control of the contract.\n', '     * @notice Renouncing to ownership will leave the contract without an owner.\n', '     * It will not be possible to call the functions with the `onlyOwner`\n', '     * modifier anymore.\n', '     */\n', '    function renounceOwnership() public onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        _transferOwnership(newOwner);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers control of the contract to a newOwner.\n', '     * @param newOwner The address to transfer ownership to.\n', '     */\n', '    function _transferOwnership(address newOwner) internal {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '// File: openzeppelin-solidity/contracts/math/SafeMath.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Unsigned math operations with safety checks that revert on error\n', ' */\n', 'library SafeMath {\n', '    /**\n', '    * @dev Multiplies two unsigned integers, reverts on overflow.\n', '    */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.\n', '    */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '    */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Adds two unsigned integers, reverts on overflow.\n', '    */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a);\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '    * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),\n', '    * reverts when dividing by zero.\n', '    */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '// File: contracts/generators/ColourGenerator.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '\n', 'contract ColourGenerator is Ownable {\n', '\n', '    uint256 internal randNonce = 0;\n', '\n', '    event Colours(uint256 exteriorColorway, uint256 backgroundColorway);\n', '\n', '    uint256 public exteriors = 20;\n', '    uint256 public backgrounds = 8;\n', '\n', '    function generate(address _sender)\n', '    external\n', '    returns (\n', '        uint256 exteriorColorway,\n', '        uint256 backgroundColorway\n', '    ) {\n', '        bytes32 hash = blockhash(block.number);\n', '\n', '        uint256 exteriorColorwayRandom = generate(hash, _sender, exteriors);\n', '        uint256 backgroundColorwayRandom = generate(hash, _sender, backgrounds);\n', '\n', '        emit Colours(exteriorColorwayRandom, backgroundColorwayRandom);\n', '\n', '        return (exteriorColorwayRandom, backgroundColorwayRandom);\n', '    }\n', '\n', '    function generate(bytes32 _hash, address _sender, uint256 _max) internal returns (uint256) {\n', '        randNonce++;\n', '        bytes memory packed = abi.encodePacked(_hash, _sender, randNonce);\n', '        return uint256(keccak256(packed)) % _max;\n', '    }\n', '\n', '    function updateExteriors(uint256 _exteriors) public onlyOwner {\n', '        exteriors = _exteriors;\n', '    }\n', '\n', '    function updateBackgrounds(uint256 _backgrounds) public onlyOwner {\n', '        backgrounds = _backgrounds;\n', '    }\n', '}\n', '\n', '// File: contracts/generators/LogicGenerator.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '\n', 'contract LogicGenerator is Ownable {\n', '\n', '    uint256 internal randNonce = 0;\n', '\n', '    event Generated(\n', '        uint256 city,\n', '        uint256 building,\n', '        uint256 base,\n', '        uint256 body,\n', '        uint256 roof,\n', '        uint256 special\n', '    );\n', '\n', '    uint256[] public cityPercentages;\n', '\n', '    mapping(uint256 => uint256[]) public cityMappings;\n', '\n', '    mapping(uint256 => uint256[]) public buildingBaseMappings;\n', '    mapping(uint256 => uint256[]) public buildingBodyMappings;\n', '    mapping(uint256 => uint256[]) public buildingRoofMappings;\n', '\n', '    uint256 public specialModulo = 7;\n', '    uint256 public specialNo = 11;\n', '\n', '    function generate(address _sender)\n', '    external\n', '    returns (uint256 city, uint256 building, uint256 base, uint256 body, uint256 roof, uint256 special) {\n', '        bytes32 hash = blockhash(block.number);\n', '\n', '        uint256 aCity = cityPercentages[generate(hash, _sender, cityPercentages.length)];\n', '\n', '        uint256 aBuilding = cityMappings[aCity][generate(hash, _sender, cityMappings[aCity].length)];\n', '\n', '        uint256 aBase = buildingBaseMappings[aBuilding][generate(hash, _sender, buildingBaseMappings[aBuilding].length)];\n', '        uint256 aBody = buildingBodyMappings[aBuilding][generate(hash, _sender, buildingBodyMappings[aBuilding].length)];\n', '        uint256 aRoof = buildingRoofMappings[aBuilding][generate(hash, _sender, buildingRoofMappings[aBuilding].length)];\n', '        uint256 aSpecial = 0;\n', '\n', '        // 1 in X roughly\n', '        if (isSpecial(block.number)) {\n', '            aSpecial = generate(hash, _sender, specialNo);\n', '        }\n', '\n', '        emit Generated(aCity, aBuilding, aBase, aBody, aRoof, aSpecial);\n', '\n', '        return (aCity, aBuilding, aBase, aBody, aRoof, aSpecial);\n', '    }\n', '\n', '    function generate(bytes32 _hash, address _sender, uint256 _max) internal returns (uint256) {\n', '        randNonce++;\n', '        bytes memory packed = abi.encodePacked(_hash, _sender, randNonce);\n', '        return uint256(keccak256(packed)) % _max;\n', '    }\n', '\n', '    function isSpecial(uint256 _blocknumber) public view returns (bool) {\n', '        return (_blocknumber % specialModulo) == 0;\n', '    }\n', '\n', '    function updateBuildingBaseMappings(uint256 _building, uint256[] memory _params) public onlyOwner {\n', '        buildingBaseMappings[_building] = _params;\n', '    }\n', '\n', '    function updateBuildingBodyMappings(uint256 _building, uint256[] memory _params) public onlyOwner {\n', '        buildingBodyMappings[_building] = _params;\n', '    }\n', '\n', '    function updateBuildingRoofMappings(uint256 _building, uint256[] memory _params) public onlyOwner {\n', '        buildingRoofMappings[_building] = _params;\n', '    }\n', '\n', '    function updateSpecialModulo(uint256 _specialModulo) public onlyOwner {\n', '        specialModulo = _specialModulo;\n', '    }\n', '\n', '    function updateSpecialNo(uint256 _specialNo) public onlyOwner {\n', '        specialNo = _specialNo;\n', '    }\n', '\n', '    function updateCityPercentages(uint256[] memory _params) public onlyOwner {\n', '        cityPercentages = _params;\n', '    }\n', '\n', '    function updateCityMappings(uint256 _cityIndex, uint256[] memory _params) public onlyOwner {\n', '        cityMappings[_cityIndex] = _params;\n', '    }\n', '\n', '}\n', '\n', '// File: contracts/FundsSplitter.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '\n', '\n', 'contract FundsSplitter is Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    address payable public blockcities;\n', '    address payable public partner;\n', '\n', '    uint256 public partnerRate = 15;\n', '\n', '    constructor (address payable _blockcities, address payable _partner) public {\n', '        blockcities = _blockcities;\n', '        partner = _partner;\n', '    }\n', '\n', '    function splitFunds(uint256 _totalPrice) internal {\n', '        if (msg.value > 0) {\n', '            uint256 refund = msg.value.sub(_totalPrice);\n', '\n', '            // overpaid...\n', '            if (refund > 0) {\n', '                msg.sender.transfer(refund);\n', '            }\n', '\n', '            // work out the amount to split and send it\n', '            uint256 partnerAmount = _totalPrice.div(100).mul(partnerRate);\n', '            partner.transfer(partnerAmount);\n', '\n', '            // send remaining amount to blockCities wallet\n', '            uint256 remaining = _totalPrice.sub(partnerAmount);\n', '            blockcities.transfer(remaining);\n', '        }\n', '    }\n', '\n', '    function updatePartnerAddress(address payable _partner) onlyOwner public {\n', '        partner = _partner;\n', '    }\n', '\n', '    function updatePartnerRate(uint256 _techPartnerRate) onlyOwner public {\n', '        partnerRate = _techPartnerRate;\n', '    }\n', '\n', '    function updateBlockcitiesAddress(address payable _blockcities) onlyOwner public {\n', '        blockcities = _blockcities;\n', '    }\n', '}\n', '\n', '// File: contracts/libs/Strings.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', 'library Strings {\n', '\n', '    // via https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol\n', '    function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) internal pure returns (string memory _concatenatedString) {\n', '        bytes memory _ba = bytes(_a);\n', '        bytes memory _bb = bytes(_b);\n', '        bytes memory _bc = bytes(_c);\n', '        bytes memory _bd = bytes(_d);\n', '        bytes memory _be = bytes(_e);\n', '        string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);\n', '        bytes memory babcde = bytes(abcde);\n', '        uint k = 0;\n', '        uint i = 0;\n', '        for (i = 0; i < _ba.length; i++) {\n', '            babcde[k++] = _ba[i];\n', '        }\n', '        for (i = 0; i < _bb.length; i++) {\n', '            babcde[k++] = _bb[i];\n', '        }\n', '        for (i = 0; i < _bc.length; i++) {\n', '            babcde[k++] = _bc[i];\n', '        }\n', '        for (i = 0; i < _bd.length; i++) {\n', '            babcde[k++] = _bd[i];\n', '        }\n', '        for (i = 0; i < _be.length; i++) {\n', '            babcde[k++] = _be[i];\n', '        }\n', '        return string(babcde);\n', '    }\n', '\n', '    function strConcat(string memory _a, string memory _b) internal pure returns (string memory) {\n', '        return strConcat(_a, _b, "", "", "");\n', '    }\n', '\n', '    function strConcat(string memory _a, string memory _b, string memory _c) internal pure returns (string memory) {\n', '        return strConcat(_a, _b, _c, "", "");\n', '    }\n', '\n', '    function uint2str(uint _i) internal pure returns (string memory _uintAsString) {\n', '        if (_i == 0) {\n', '            return "0";\n', '        }\n', '        uint j = _i;\n', '        uint len;\n', '        while (j != 0) {\n', '            len++;\n', '            j /= 10;\n', '        }\n', '        bytes memory bstr = new bytes(len);\n', '        uint k = len - 1;\n', '        while (_i != 0) {\n', '            bstr[k--] = byte(uint8(48 + _i % 10));\n', '            _i /= 10;\n', '        }\n', '        return string(bstr);\n', '    }\n', '}\n', '\n', '// File: contracts/IBlockCitiesCreator.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', 'interface IBlockCitiesCreator {\n', '    function createBuilding(\n', '        uint256 _exteriorColorway,\n', '        uint256 _backgroundColorway,\n', '        uint256 _city,\n', '        uint256 _building,\n', '        uint256 _base,\n', '        uint256 _body,\n', '        uint256 _roof,\n', '        uint256 _special,\n', '        address _architect\n', '    ) external returns (uint256 _tokenId);\n', '}\n', '\n', '// File: contracts/BlockCitiesVendingMachine.sol\n', '\n', 'pragma solidity ^0.5.0;\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', 'contract BlockCitiesVendingMachine is Ownable, FundsSplitter {\n', '    using SafeMath for uint256;\n', '\n', '    event VendingMachineTriggered(\n', '        uint256 indexed _tokenId,\n', '        address indexed _architect\n', '    );\n', '\n', '    event CreditAdded(address indexed _to, uint256 _amount);\n', '\n', '    event PriceDiscountBandsChanged(uint256[2] _priceDiscountBands);\n', '\n', '    event PriceStepInWeiChanged(\n', '        uint256 _oldPriceStepInWei,\n', '        uint256 _newPriceStepInWei\n', '    );\n', '\n', '    event PricePerBuildingInWeiChanged(\n', '        uint256 _oldPricePerBuildingInWei,\n', '        uint256 _newPricePerBuildingInWei\n', '    );\n', '\n', '    event FloorPricePerBuildingInWeiChanged(\n', '        uint256 _oldFloorPricePerBuildingInWei,\n', '        uint256 _newFloorPricePerBuildingInWei\n', '    );\n', '\n', '    event CeilingPricePerBuildingInWeiChanged(\n', '        uint256 _oldCeilingPricePerBuildingInWei,\n', '        uint256 _newCeilingPricePerBuildingInWei\n', '    );\n', '\n', '    event BlockStepChanged(\n', '        uint256 _oldBlockStep,\n', '        uint256 _newBlockStep\n', '    );\n', '\n', '    event LastSaleBlockChanged(\n', '        uint256 _oldLastSaleBlock,\n', '        uint256 _newLastSaleBlock\n', '    );\n', '\n', '    struct Colour {\n', '        uint256 exteriorColorway;\n', '        uint256 backgroundColorway;\n', '    }\n', '\n', '    struct Building {\n', '        uint256 city;\n', '        uint256 building;\n', '        uint256 base;\n', '        uint256 body;\n', '        uint256 roof;\n', '        uint256 special;\n', '    }\n', '\n', '    LogicGenerator public logicGenerator;\n', '\n', '    ColourGenerator public colourGenerator;\n', '\n', '    IBlockCitiesCreator public blockCities;\n', '\n', '    mapping(address => uint256) public credits;\n', '\n', '    uint256 public totalPurchasesInWei = 0;\n', '    uint256[2] public priceDiscountBands = [80, 70];\n', '\n', '    uint256 public floorPricePerBuildingInWei = 0.05 ether;\n', '\n', '    uint256 public ceilingPricePerBuildingInWei = 0.15 ether;\n', '\n', '    // use totalPrice() to calculate current weighted price\n', '    uint256 pricePerBuildingInWei = 0.075 ether;\n', '\n', '    uint256 public priceStepInWei = 0.0003 ether;\n', '\n', '    // 120 is approx 30 mins\n', '    uint256 public blockStep = 120;\n', '\n', '    uint256 public lastSaleBlock = 0;\n', '    uint256 public lastSalePrice = 0;\n', '\n', '    constructor (\n', '        LogicGenerator _logicGenerator,\n', '        ColourGenerator _colourGenerator,\n', '        IBlockCitiesCreator _blockCities,\n', '        address payable _blockCitiesAddress,\n', '        address payable _partnerAddress\n', '    ) public FundsSplitter(_blockCitiesAddress, _partnerAddress) {\n', '        logicGenerator = _logicGenerator;\n', '        colourGenerator = _colourGenerator;\n', '        blockCities = _blockCities;\n', '    }\n', '\n', '    function mintBuilding() public payable returns (uint256 _tokenId) {\n', '        uint256 currentPrice = totalPrice(1);\n', '        require(\n', '            credits[msg.sender] > 0 || msg.value >= currentPrice,\n', '            "Must supply at least the required minimum purchase value or have credit"\n', '        );\n', '\n', '        _adjustCredits(currentPrice, 1);\n', '\n', '        uint256 tokenId = _generate(msg.sender);\n', '\n', '        _stepIncrease();\n', '\n', '        return tokenId;\n', '    }\n', '\n', '    function mintBuildingTo(address _to) public payable returns (uint256 _tokenId) {\n', '        uint256 currentPrice = totalPrice(1);\n', '        require(\n', '            credits[msg.sender] > 0 || msg.value >= currentPrice,\n', '            "Must supply at least the required minimum purchase value or have credit"\n', '        );\n', '\n', '        _adjustCredits(currentPrice, 1);\n', '\n', '        uint256 tokenId = _generate(_to);\n', '\n', '        _stepIncrease();\n', '\n', '        return tokenId;\n', '    }\n', '\n', '    function mintBatch(uint256 _numberOfBuildings) public payable returns (uint256[] memory _tokenIds) {\n', '        uint256 currentPrice = totalPrice(_numberOfBuildings);\n', '        require(\n', '            credits[msg.sender] >= _numberOfBuildings || msg.value >= currentPrice,\n', '            "Must supply at least the required minimum purchase value or have credit"\n', '        );\n', '\n', '        _adjustCredits(currentPrice, _numberOfBuildings);\n', '\n', '        uint256[] memory generatedTokenIds = new uint256[](_numberOfBuildings);\n', '\n', '        for (uint i = 0; i < _numberOfBuildings; i++) {\n', '            generatedTokenIds[i] = _generate(msg.sender);\n', '        }\n', '\n', '        _stepIncrease();\n', '\n', '        return generatedTokenIds;\n', '    }\n', '\n', '    function mintBatchTo(address _to, uint256 _numberOfBuildings) public payable returns (uint256[] memory _tokenIds) {\n', '        uint256 currentPrice = totalPrice(_numberOfBuildings);\n', '        require(\n', '            credits[msg.sender] >= _numberOfBuildings || msg.value >= currentPrice,\n', '            "Must supply at least the required minimum purchase value or have credit"\n', '        );\n', '\n', '        _adjustCredits(currentPrice, _numberOfBuildings);\n', '\n', '        uint256[] memory generatedTokenIds = new uint256[](_numberOfBuildings);\n', '\n', '        for (uint i = 0; i < _numberOfBuildings; i++) {\n', '            generatedTokenIds[i] = _generate(_to);\n', '        }\n', '\n', '        _stepIncrease();\n', '\n', '        return generatedTokenIds;\n', '    }\n', '\n', '    function _generate(address _to) internal returns (uint256 _tokenId) {\n', '        Building memory building = _generateBuilding();\n', '        Colour memory colour = _generateColours();\n', '\n', '        uint256 tokenId = blockCities.createBuilding(\n', '            colour.exteriorColorway,\n', '            colour.backgroundColorway,\n', '            building.city,\n', '            building.building,\n', '            building.base,\n', '            building.body,\n', '            building.roof,\n', '            building.special,\n', '            _to\n', '        );\n', '\n', '        emit VendingMachineTriggered(tokenId, _to);\n', '\n', '        return tokenId;\n', '    }\n', '\n', '    function _generateColours() internal returns (Colour memory){\n', '        (uint256 _exteriorColorway, uint256 _backgroundColorway) = colourGenerator.generate(msg.sender);\n', '\n', '        return Colour({\n', '            exteriorColorway : _exteriorColorway,\n', '            backgroundColorway : _backgroundColorway\n', '            });\n', '    }\n', '\n', '    function _generateBuilding() internal returns (Building memory){\n', '        (uint256 _city, uint256 _building, uint256 _base, uint256 _body, uint256 _roof, uint256 _special) = logicGenerator.generate(msg.sender);\n', '\n', '        return Building({\n', '            city : _city,\n', '            building : _building,\n', '            base : _base,\n', '            body : _body,\n', '            roof : _roof,\n', '            special : _special\n', '            });\n', '    }\n', '\n', '    function _adjustCredits(uint256 _currentPrice, uint256 _numberOfBuildings) internal {\n', '        // use credits first\n', '        if (credits[msg.sender] >= _numberOfBuildings) {\n', '            credits[msg.sender] = credits[msg.sender].sub(_numberOfBuildings);\n', '\n', '            // refund msg.value when using up credits\n', '            if (msg.value > 0) {\n', '                msg.sender.transfer(msg.value);\n', '            }\n', '        } else {\n', '            splitFunds(_currentPrice);\n', '            totalPurchasesInWei = totalPurchasesInWei.add(_currentPrice);\n', '        }\n', '    }\n', '\n', '    function _stepIncrease() internal {\n', '        lastSalePrice = pricePerBuildingInWei;\n', '        lastSaleBlock = block.number;\n', '\n', '        pricePerBuildingInWei = pricePerBuildingInWei.add(priceStepInWei);\n', '\n', '        if (pricePerBuildingInWei >= ceilingPricePerBuildingInWei) {\n', '            pricePerBuildingInWei = ceilingPricePerBuildingInWei;\n', '        }\n', '    }\n', '\n', '    function totalPrice(uint256 _numberOfBuildings) public view returns (uint256) {\n', '\n', '        uint256 calculatedPrice = pricePerBuildingInWei;\n', '\n', '        uint256 blocksPassed = block.number - lastSaleBlock;\n', '        uint256 reduce = blocksPassed.div(blockStep).mul(priceStepInWei);\n', '\n', '        if (reduce > calculatedPrice) {\n', '            calculatedPrice = floorPricePerBuildingInWei;\n', '        }\n', '        else {\n', '            calculatedPrice = calculatedPrice.sub(reduce);\n', '        }\n', '\n', '        if (calculatedPrice < floorPricePerBuildingInWei) {\n', '            calculatedPrice = floorPricePerBuildingInWei;\n', '        }\n', '\n', '        if (_numberOfBuildings < 5) {\n', '            return _numberOfBuildings.mul(calculatedPrice);\n', '        }\n', '        else if (_numberOfBuildings < 10) {\n', '            return _numberOfBuildings.mul(calculatedPrice).div(100).mul(priceDiscountBands[0]);\n', '        }\n', '\n', '        return _numberOfBuildings.mul(calculatedPrice).div(100).mul(priceDiscountBands[1]);\n', '    }\n', '\n', '    function setPricePerBuildingInWei(uint256 _pricePerBuildingInWei) public onlyOwner returns (bool) {\n', '        emit PricePerBuildingInWeiChanged(pricePerBuildingInWei, _pricePerBuildingInWei);\n', '        pricePerBuildingInWei = _pricePerBuildingInWei;\n', '        return true;\n', '    }\n', '\n', '    function setPriceStepInWei(uint256 _priceStepInWei) public onlyOwner returns (bool) {\n', '        emit PriceStepInWeiChanged(priceStepInWei, _priceStepInWei);\n', '        priceStepInWei = _priceStepInWei;\n', '        return true;\n', '    }\n', '\n', '    function setPriceDiscountBands(uint256[2] memory _newPriceDiscountBands) public onlyOwner returns (bool) {\n', '        priceDiscountBands = _newPriceDiscountBands;\n', '\n', '        emit PriceDiscountBandsChanged(_newPriceDiscountBands);\n', '\n', '        return true;\n', '    }\n', '\n', '    function addCredit(address _to) public onlyOwner returns (bool) {\n', '        credits[_to] = credits[_to].add(1);\n', '\n', '        emit CreditAdded(_to, 1);\n', '\n', '        return true;\n', '    }\n', '\n', '    function addCreditAmount(address _to, uint256 _amount) public onlyOwner returns (bool) {\n', '        credits[_to] = credits[_to].add(_amount);\n', '\n', '        emit CreditAdded(_to, _amount);\n', '\n', '        return true;\n', '    }\n', '\n', '    function addCreditBatch(address[] memory _addresses, uint256 _amount) public onlyOwner returns (bool) {\n', '        for (uint i = 0; i < _addresses.length; i++) {\n', '            addCreditAmount(_addresses[i], _amount);\n', '        }\n', '\n', '        return true;\n', '    }\n', '\n', '    function setFloorPricePerBuildingInWei(uint256 _floorPricePerBuildingInWei) public onlyOwner returns (bool) {\n', '        emit FloorPricePerBuildingInWeiChanged(floorPricePerBuildingInWei, _floorPricePerBuildingInWei);\n', '        floorPricePerBuildingInWei = _floorPricePerBuildingInWei;\n', '        return true;\n', '    }\n', '\n', '    function setCeilingPricePerBuildingInWei(uint256 _ceilingPricePerBuildingInWei) public onlyOwner returns (bool) {\n', '        emit CeilingPricePerBuildingInWeiChanged(ceilingPricePerBuildingInWei, _ceilingPricePerBuildingInWei);\n', '        ceilingPricePerBuildingInWei = _ceilingPricePerBuildingInWei;\n', '        return true;\n', '    }\n', '\n', '    function setBlockStep(uint256 _blockStep) public onlyOwner returns (bool) {\n', '        emit BlockStepChanged(blockStep, _blockStep);\n', '        blockStep = _blockStep;\n', '        return true;\n', '    }\n', '\n', '    function setLastSaleBlock(uint256 _lastSaleBlock) public onlyOwner returns (bool) {\n', '        emit LastSaleBlockChanged(lastSaleBlock, _lastSaleBlock);\n', '        lastSaleBlock = _lastSaleBlock;\n', '        return true;\n', '    }\n', '\n', '    function setLogicGenerator(LogicGenerator _logicGenerator) public onlyOwner returns (bool) {\n', '        logicGenerator = _logicGenerator;\n', '        return true;\n', '    }\n', '\n', '    function setColourGenerator(ColourGenerator _colourGenerator) public onlyOwner returns (bool) {\n', '        colourGenerator = _colourGenerator;\n', '        return true;\n', '    }\n', '}']