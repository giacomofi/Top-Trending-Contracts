['/**\n', ' *Submitted for verification at Etherscan.io on 2021-03-11\n', '*/\n', '\n', '// File: contracts\\modules\\Ownable.sol\n', '\n', 'pragma solidity =0.5.16;\n', '\n', '/**\n', ' * @dev Contract module which provides a basic access control mechanism, where\n', ' * there is an account (an owner) that can be granted exclusive access to\n', ' * specific functions.\n', ' *\n', ' * This module is used through inheritance. It will make available the modifier\n', ' * `onlyOwner`, which can be applied to your functions to restrict their use to\n', ' * the owner.\n', ' */\n', 'contract Ownable {\n', '    address internal _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '    constructor() internal {\n', '        _owner = msg.sender;\n', '        emit OwnershipTransferred(address(0), _owner);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(isOwner(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns true if the caller is the current owner.\n', '     */\n', '    function isOwner() public view returns (bool) {\n', '        return msg.sender == _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Leaves the contract without owner. It will not be possible to call\n', '     * `onlyOwner` functions anymore. Can only be called by the current owner.\n', '     *\n', '     * NOTE: Renouncing ownership will leave the contract without an owner,\n', '     * thereby removing any functionality that is only available to the owner.\n', '     */\n', '    function renounceOwnership() public onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        _transferOwnership(newOwner);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     */\n', '    function _transferOwnership(address newOwner) internal {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '// File: contracts\\modules\\Managerable.sol\n', '\n', 'pragma solidity =0.5.16;\n', '\n', 'contract Managerable is Ownable {\n', '\n', '    address private _managerAddress;\n', '    /**\n', '     * @dev modifier, Only manager can be granted exclusive access to specific functions. \n', '     *\n', '     */\n', '    modifier onlyManager() {\n', '        require(_managerAddress == msg.sender,"Managerable: caller is not the Manager");\n', '        _;\n', '    }\n', '    /**\n', '     * @dev set manager by owner. \n', '     *\n', '     */\n', '    function setManager(address managerAddress)\n', '    public\n', '    onlyOwner\n', '    {\n', '        _managerAddress = managerAddress;\n', '    }\n', '    /**\n', '     * @dev get manager address. \n', '     *\n', '     */\n', '    function getManager()public view returns (address) {\n', '        return _managerAddress;\n', '    }\n', '}\n', '\n', '// File: contracts\\interfaces\\IFNXOracle.sol\n', '\n', 'pragma solidity =0.5.16;\n', '\n', 'interface IFNXOracle {\n', '    /**\n', '  * @notice retrieves price of an asset\n', '  * @dev function to get price for an asset\n', '  * @param asset Asset for which to get the price\n', '  * @return uint mantissa of asset price (scaled by 1e8) or zero if unset or contract paused\n', '  */\n', '    function getPrice(address asset) external view returns (uint256);\n', '    function getUnderlyingPrice(uint256 cToken) external view returns (uint256);\n', '    function getPrices(uint256[] calldata assets) external view returns (uint256[]memory);\n', '    function getAssetAndUnderlyingPrice(address asset,uint256 underlying) external view returns (uint256,uint256);\n', '//    function getSellOptionsPrice(address oToken) external view returns (uint256);\n', '//    function getBuyOptionsPrice(address oToken) external view returns (uint256);\n', '}\n', 'contract ImportOracle is Ownable{\n', '    IFNXOracle internal _oracle;\n', '    function oraclegetPrices(uint256[] memory assets) internal view returns (uint256[]memory){\n', '        uint256[] memory prices = _oracle.getPrices(assets);\n', '        uint256 len = assets.length;\n', '        for (uint i=0;i<len;i++){\n', '        require(prices[i] >= 100 && prices[i] <= 1e30);\n', '        }\n', '        return prices;\n', '    }\n', '    function oraclePrice(address asset) internal view returns (uint256){\n', '        uint256 price = _oracle.getPrice(asset);\n', '        require(price >= 100 && price <= 1e30);\n', '        return price;\n', '    }\n', '    function oracleUnderlyingPrice(uint256 cToken) internal view returns (uint256){\n', '        uint256 price = _oracle.getUnderlyingPrice(cToken);\n', '        require(price >= 100 && price <= 1e30);\n', '        return price;\n', '    }\n', '    function oracleAssetAndUnderlyingPrice(address asset,uint256 cToken) internal view returns (uint256,uint256){\n', '        (uint256 price1,uint256 price2) = _oracle.getAssetAndUnderlyingPrice(asset,cToken);\n', '        require(price1 >= 100 && price1 <= 1e30);\n', '        require(price2 >= 100 && price2 <= 1e30);\n', '        return (price1,price2);\n', '    }\n', '    function getOracleAddress() public view returns(address){\n', '        return address(_oracle);\n', '    }\n', '    function setOracleAddress(address oracle)public onlyOwner{\n', '        _oracle = IFNXOracle(oracle);\n', '    }\n', '}\n', '\n', '// File: contracts\\modules\\whiteList.sol\n', '\n', 'pragma solidity =0.5.16;\n', '    /**\n', '     * @dev Implementation of a whitelist which filters a eligible uint32.\n', '     */\n', 'library whiteListUint32 {\n', '    /**\n', '     * @dev add uint32 into white list.\n', '     * @param whiteList the storage whiteList.\n', '     * @param temp input value\n', '     */\n', '\n', '    function addWhiteListUint32(uint32[] storage whiteList,uint32 temp) internal{\n', '        if (!isEligibleUint32(whiteList,temp)){\n', '            whiteList.push(temp);\n', '        }\n', '    }\n', '    /**\n', '     * @dev remove uint32 from whitelist.\n', '     */\n', '    function removeWhiteListUint32(uint32[] storage whiteList,uint32 temp)internal returns (bool) {\n', '        uint256 len = whiteList.length;\n', '        uint256 i=0;\n', '        for (;i<len;i++){\n', '            if (whiteList[i] == temp)\n', '                break;\n', '        }\n', '        if (i<len){\n', '            if (i!=len-1) {\n', '                whiteList[i] = whiteList[len-1];\n', '            }\n', '            whiteList.length--;\n', '            return true;\n', '        }\n', '        return false;\n', '    }\n', '    function isEligibleUint32(uint32[] memory whiteList,uint32 temp) internal pure returns (bool){\n', '        uint256 len = whiteList.length;\n', '        for (uint256 i=0;i<len;i++){\n', '            if (whiteList[i] == temp)\n', '                return true;\n', '        }\n', '        return false;\n', '    }\n', '    function _getEligibleIndexUint32(uint32[] memory whiteList,uint32 temp) internal pure returns (uint256){\n', '        uint256 len = whiteList.length;\n', '        uint256 i=0;\n', '        for (;i<len;i++){\n', '            if (whiteList[i] == temp)\n', '                break;\n', '        }\n', '        return i;\n', '    }\n', '}\n', '    /**\n', '     * @dev Implementation of a whitelist which filters a eligible uint256.\n', '     */\n', 'library whiteListUint256 {\n', '    // add whiteList\n', '    function addWhiteListUint256(uint256[] storage whiteList,uint256 temp) internal{\n', '        if (!isEligibleUint256(whiteList,temp)){\n', '            whiteList.push(temp);\n', '        }\n', '    }\n', '    function removeWhiteListUint256(uint256[] storage whiteList,uint256 temp)internal returns (bool) {\n', '        uint256 len = whiteList.length;\n', '        uint256 i=0;\n', '        for (;i<len;i++){\n', '            if (whiteList[i] == temp)\n', '                break;\n', '        }\n', '        if (i<len){\n', '            if (i!=len-1) {\n', '                whiteList[i] = whiteList[len-1];\n', '            }\n', '            whiteList.length--;\n', '            return true;\n', '        }\n', '        return false;\n', '    }\n', '    function isEligibleUint256(uint256[] memory whiteList,uint256 temp) internal pure returns (bool){\n', '        uint256 len = whiteList.length;\n', '        for (uint256 i=0;i<len;i++){\n', '            if (whiteList[i] == temp)\n', '                return true;\n', '        }\n', '        return false;\n', '    }\n', '    function _getEligibleIndexUint256(uint256[] memory whiteList,uint256 temp) internal pure returns (uint256){\n', '        uint256 len = whiteList.length;\n', '        uint256 i=0;\n', '        for (;i<len;i++){\n', '            if (whiteList[i] == temp)\n', '                break;\n', '        }\n', '        return i;\n', '    }\n', '}\n', '    /**\n', '     * @dev Implementation of a whitelist which filters a eligible address.\n', '     */\n', 'library whiteListAddress {\n', '    // add whiteList\n', '    function addWhiteListAddress(address[] storage whiteList,address temp) internal{\n', '        if (!isEligibleAddress(whiteList,temp)){\n', '            whiteList.push(temp);\n', '        }\n', '    }\n', '    function removeWhiteListAddress(address[] storage whiteList,address temp)internal returns (bool) {\n', '        uint256 len = whiteList.length;\n', '        uint256 i=0;\n', '        for (;i<len;i++){\n', '            if (whiteList[i] == temp)\n', '                break;\n', '        }\n', '        if (i<len){\n', '            if (i!=len-1) {\n', '                whiteList[i] = whiteList[len-1];\n', '            }\n', '            whiteList.length--;\n', '            return true;\n', '        }\n', '        return false;\n', '    }\n', '    function isEligibleAddress(address[] memory whiteList,address temp) internal pure returns (bool){\n', '        uint256 len = whiteList.length;\n', '        for (uint256 i=0;i<len;i++){\n', '            if (whiteList[i] == temp)\n', '                return true;\n', '        }\n', '        return false;\n', '    }\n', '    function _getEligibleIndexAddress(address[] memory whiteList,address temp) internal pure returns (uint256){\n', '        uint256 len = whiteList.length;\n', '        uint256 i=0;\n', '        for (;i<len;i++){\n', '            if (whiteList[i] == temp)\n', '                break;\n', '        }\n', '        return i;\n', '    }\n', '}\n', '\n', '// File: contracts\\modules\\underlyingAssets.sol\n', '\n', 'pragma solidity =0.5.16;\n', '\n', '\n', '    /**\n', '     * @dev Implementation of a underlyingAssets filters a eligible underlying.\n', '     */\n', 'contract UnderlyingAssets is Ownable {\n', '    using whiteListUint32 for uint32[];\n', '    // The eligible underlying list\n', '    uint32[] internal underlyingAssets;\n', '    /**\n', '     * @dev Implementation of add an eligible underlying into the underlyingAssets.\n', '     * @param underlying new eligible underlying.\n', '     */\n', '    function addUnderlyingAsset(uint32 underlying)public onlyOwner{\n', '        underlyingAssets.addWhiteListUint32(underlying);\n', '    }\n', '    function setUnderlyingAsset(uint32[] memory underlyings)public onlyOwner{\n', '        underlyingAssets = underlyings;\n', '    }\n', '    /**\n', '     * @dev Implementation of revoke an invalid underlying from the underlyingAssets.\n', '     * @param removeUnderlying revoked underlying.\n', '     */\n', '    function removeUnderlyingAssets(uint32 removeUnderlying)public onlyOwner returns(bool) {\n', '        return underlyingAssets.removeWhiteListUint32(removeUnderlying);\n', '    }\n', '    /**\n', '     * @dev Implementation of getting the eligible underlyingAssets.\n', '     */\n', '    function getUnderlyingAssets()public view returns (uint32[] memory){\n', '        return underlyingAssets;\n', '    }\n', '    /**\n', '     * @dev Implementation of testing whether the input underlying is eligible.\n', '     * @param underlying input underlying for testing.\n', '     */    \n', '    function isEligibleUnderlyingAsset(uint32 underlying) public view returns (bool){\n', '        return underlyingAssets.isEligibleUint32(underlying);\n', '    }\n', '    function _getEligibleUnderlyingIndex(uint32 underlying) internal view returns (uint256){\n', '        return underlyingAssets._getEligibleIndexUint32(underlying);\n', '    }\n', '}\n', '\n', '// File: contracts\\interfaces\\IVolatility.sol\n', '\n', 'pragma solidity =0.5.16;\n', '\n', 'interface IVolatility {\n', '    function calculateIv(uint32 underlying,uint8 optType,uint256 expiration,uint256 currentPrice,uint256 strikePrice)external view returns (uint256);\n', '}\n', 'contract ImportVolatility is Ownable{\n', '    IVolatility internal _volatility;\n', '    function getVolatilityAddress() public view returns(address){\n', '        return address(_volatility);\n', '    }\n', '    function setVolatilityAddress(address volatility)public onlyOwner{\n', '        _volatility = IVolatility(volatility);\n', '    }\n', '}\n', '\n', '// File: contracts\\interfaces\\IOptionsPrice.sol\n', '\n', 'pragma solidity =0.5.16;\n', '\n', 'interface IOptionsPrice {\n', '    function getOptionsPrice(uint256 currentPrice, uint256 strikePrice, uint256 expiration,uint32 underlying,uint8 optType)external view returns (uint256);\n', '    function getOptionsPrice_iv(uint256 currentPrice, uint256 strikePrice, uint256 expiration,\n', '                uint256 ivNumerator,uint8 optType)external view returns (uint256);\n', '    function calOptionsPriceRatio(uint256 selfOccupied,uint256 totalOccupied,uint256 totalCollateral) external view returns (uint256);\n', '}\n', 'contract ImportOptionsPrice is Ownable{\n', '    IOptionsPrice internal _optionsPrice;\n', '    function getOptionsPriceAddress() public view returns(address){\n', '        return address(_optionsPrice);\n', '    }\n', '    function setOptionsPriceAddress(address optionsPrice)public onlyOwner{\n', '        _optionsPrice = IOptionsPrice(optionsPrice);\n', '    }\n', '}\n', '\n', '// File: contracts\\modules\\Operator.sol\n', '\n', 'pragma solidity =0.5.16;\n', '\n', '\n', '/**\n', ' * @dev Contract module which provides a basic access control mechanism, where\n', ' * each operator can be granted exclusive access to specific functions.\n', ' *\n', ' */\n', 'contract Operator is Ownable {\n', '    using whiteListAddress for address[];\n', '    address[] private _operatorList;\n', '    /**\n', '     * @dev modifier, every operator can be granted exclusive access to specific functions. \n', '     *\n', '     */\n', '    modifier onlyOperator() {\n', '        require(_operatorList.isEligibleAddress(msg.sender),"Managerable: caller is not the Operator");\n', '        _;\n', '    }\n', '    /**\n', '     * @dev modifier, Only indexed operator can be granted exclusive access to specific functions. \n', '     *\n', '     */\n', '    modifier onlyOperatorIndex(uint256 index) {\n', '        require(_operatorList.length>index && _operatorList[index] == msg.sender,"Operator: caller is not the eligible Operator");\n', '        _;\n', '    }\n', '    /**\n', '     * @dev add a new operator by owner. \n', '     *\n', '     */\n', '    function addOperator(address addAddress)public onlyOwner{\n', '        _operatorList.addWhiteListAddress(addAddress);\n', '    }\n', '    /**\n', '     * @dev modify indexed operator by owner. \n', '     *\n', '     */\n', '    function setOperator(uint256 index,address addAddress)public onlyOwner{\n', '        _operatorList[index] = addAddress;\n', '    }\n', '    /**\n', '     * @dev remove operator by owner. \n', '     *\n', '     */\n', '    function removeOperator(address removeAddress)public onlyOwner returns (bool){\n', '        return _operatorList.removeWhiteListAddress(removeAddress);\n', '    }\n', '    /**\n', '     * @dev get all operators. \n', '     *\n', '     */\n', '    function getOperator()public view returns (address[] memory) {\n', '        return _operatorList;\n', '    }\n', '    /**\n', '     * @dev set all operators by owner. \n', '     *\n', '     */\n', '    function setOperators(address[] memory operators)public onlyOwner {\n', '        _operatorList = operators;\n', '    }\n', '}\n', '\n', '// File: contracts\\modules\\ImputRange.sol\n', '\n', 'pragma solidity =0.5.16;\n', '\n', '\n', 'contract ImputRange is Ownable {\n', '    \n', '    //The maximum input amount limit.\n', '    uint256 private maxAmount = 1e30;\n', '    //The minimum input amount limit.\n', '    uint256 private minAmount = 1e2;\n', '    \n', '    modifier InRange(uint256 amount) {\n', '        require(maxAmount>=amount && minAmount<=amount,"input amount is out of input amount range");\n', '        _;\n', '    }\n', '    /**\n', '     * @dev Determine whether the input amount is within the valid range\n', '     * @param Amount Test value which is user input\n', '     */\n', '    function isInputAmountInRange(uint256 Amount)public view returns (bool){\n', '        return(maxAmount>=Amount && minAmount<=Amount);\n', '    }\n', '    /*\n', '    function isInputAmountSmaller(uint256 Amount)public view returns (bool){\n', '        return maxAmount>=amount;\n', '    }\n', '    function isInputAmountLarger(uint256 Amount)public view returns (bool){\n', '        return minAmount<=amount;\n', '    }\n', '    */\n', '    modifier Smaller(uint256 amount) {\n', '        require(maxAmount>=amount,"input amount is larger than maximium");\n', '        _;\n', '    }\n', '    modifier Larger(uint256 amount) {\n', '        require(minAmount<=amount,"input amount is smaller than maximium");\n', '        _;\n', '    }\n', '    /**\n', '     * @dev get the valid range of input amount\n', '     */\n', '    function getInputAmountRange() public view returns(uint256,uint256) {\n', '        return (minAmount,maxAmount);\n', '    }\n', '    /**\n', '     * @dev set the valid range of input amount\n', '     * @param _minAmount the minimum input amount limit\n', '     * @param _maxAmount the maximum input amount limit\n', '     */\n', '    function setInputAmountRange(uint256 _minAmount,uint256 _maxAmount) public onlyOwner{\n', '        minAmount = _minAmount;\n', '        maxAmount = _maxAmount;\n', '    }        \n', '}\n', '\n', '// File: contracts\\OptionsPool\\OptionsData.sol\n', '\n', 'pragma solidity =0.5.16;\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', 'contract OptionsData is UnderlyingAssets,ImputRange,Managerable,ImportOracle,ImportVolatility,ImportOptionsPrice,Operator{\n', '\n', '        // store option info\n', '        struct OptionsInfo {\n', "        address     owner;      // option's owner\n", '        uint8   \toptType;    //0 for call, 1 for put\n', '        uint24\t\tunderlying; // underlying ID, 1 for BTC,2 for ETH\n', '        uint64      optionsPrice;\n', '\n', "        address     settlement;    //user's settlement paying for option. \n", '        uint64      createTime;\n', '        uint32\t\texpiration; //\n', '\n', '\n', '        uint128     amount; \n', '        uint128     settlePrice;\n', '\n', '        uint128     strikePrice;    //  strike price\t\t\n', '        uint32      priceRate;    //underlying Price\t\n', '        uint64      iv;\n', '        uint32      extra;\n', '    }\n', '\n', '    uint256 internal limitation = 1 hours;\n', '    //all options information list\n', '    OptionsInfo[] internal allOptions;\n', '    //user options balances\n', '    mapping(address=>uint64[]) internal optionsBalances;\n', '    //expiration whitelist\n', '    uint32[] internal expirationList;\n', '    \n', '    // first option position which is needed calculate.\n', '    uint256 internal netWorthirstOption;\n', "    // options latest networth balance. store all options's net worth share started from first option.\n", '    mapping(address=>int256) internal optionsLatestNetWorth;\n', '\n', '    // first option position which is needed calculate.\n', '    uint256 internal occupiedFirstOption; \n', '    //latest calcutated Options Occupied value.\n', '    uint256 internal callOccupied;\n', '    uint256 internal putOccupied;\n', '    //latest Options volatile occupied value when bought or selled options.\n', '    int256 internal callLatestOccupied;\n', '    int256 internal putLatestOccupied;\n', '\n', '    /**\n', '     * @dev Emitted when `owner` create a new option. \n', "     * @param owner new option's owner\n", "     * @param optionID new option's id\n", "     * @param optionID new option's type \n", "     * @param underlying new option's underlying \n", "     * @param expiration new option's expiration timestamp\n", "     * @param strikePrice  new option's strikePrice\n", "     * @param amount  new option's amount\n", '     */\n', '    event CreateOption(address indexed owner,uint256 indexed optionID,uint8 optType,uint32 underlying,uint256 expiration,uint256 strikePrice,uint256 amount);\n', '    /**\n', '     * @dev Emitted when `owner` burn `amount` his option which id is `optionID`. \n', '     */    \n', '    event BurnOption(address indexed owner,uint256 indexed optionID,uint amount);\n', '    event DebugEvent(uint256 id,uint256 value1,uint256 value2);\n', '}\n', '/*\n', 'contract OptionsDataV2 is OptionsData{\n', '        // store option info\n', '    struct OptionsInfoV2 {\n', '        uint64     optionID;    //an increasing nubmer id, begin from one.\n', '        uint64\t\texpiration; // Expiration timestamp\n', '        uint128     strikePrice;    //strike price\n', '        uint8   \toptType;    //0 for call, 1 for put\n', '        uint32\t\tunderlying; // underlying ID, 1 for BTC,2 for ETH\n', "        address     owner;      // option's owner\n", '        uint256     amount;         // mint amount\n', '    }\n', '    // store option extra info\n', '    struct OptionsInfoExV2 {\n', "        address      settlement;    //user's settlement paying for option. \n", "        uint128      tokenTimePrice; //option's buying price based on settlement, used for options share calculation\n", '        uint128      underlyingPrice;//underlying price when option is created.\n', "        uint128      fullPrice;      //option's buying price.\n", "        uint128      ivNumerator;   // option's iv numerator when option is created.\n", "//        uint256      ivDenominator;// option's iv denominator when option is created.\n", '    }\n', '        //all options information list\n', '    OptionsInfoV2[] internal allOptionsV2;\n', "    // all option's extra information map\n", '    mapping(uint256=>OptionsInfoExV2) internal optionExtraMapV2;\n', '        //user options balances\n', '//    mapping(address=>uint64[]) internal optionsBalancesV2;\n', '}\n', '*/\n', '\n', '// File: contracts\\Proxy\\baseProxy.sol\n', '\n', 'pragma solidity =0.5.16;\n', '\n', '/**\n', ' * @title  baseProxy Contract\n', '\n', ' */\n', 'contract baseProxy is Ownable {\n', '    address public implementation;\n', '    constructor(address implementation_) public {\n', '        // Creator of the contract is admin during initialization\n', '        implementation = implementation_; \n', '        (bool success,) = implementation_.delegatecall(abi.encodeWithSignature("initialize()"));\n', '        require(success);\n', '    }\n', '    function getImplementation()public view returns(address){\n', '        return implementation;\n', '    }\n', '    function setImplementation(address implementation_)public onlyOwner{\n', '        implementation = implementation_; \n', '        (bool success,) = implementation_.delegatecall(abi.encodeWithSignature("update()"));\n', '        require(success);\n', '    }\n', '\n', '    /**\n', '     * @notice Delegates execution to the implementation contract\n', '     * @dev It returns to the external caller whatever the implementation returns or forwards reverts\n', '     * @param data The raw data to delegatecall\n', '     * @return The returned bytes from the delegatecall\n', '     */\n', '    function delegateToImplementation(bytes memory data) public returns (bytes memory) {\n', '        (bool success, bytes memory returnData) = implementation.delegatecall(data);\n', '        assembly {\n', '            if eq(success, 0) {\n', '                revert(add(returnData, 0x20), returndatasize)\n', '            }\n', '        }\n', '        return returnData;\n', '    }\n', '\n', '    /**\n', '     * @notice Delegates execution to an implementation contract\n', '     * @dev It returns to the external caller whatever the implementation returns or forwards reverts\n', '     *  There are an additional 2 prefix uints from the wrapper returndata, which we ignore since we make an extra hop.\n', '     * @param data The raw data to delegatecall\n', '     * @return The returned bytes from the delegatecall\n', '     */\n', '    function delegateToViewImplementation(bytes memory data) public view returns (bytes memory) {\n', '        (bool success, bytes memory returnData) = address(this).staticcall(abi.encodeWithSignature("delegateToImplementation(bytes)", data));\n', '        assembly {\n', '            if eq(success, 0) {\n', '                revert(add(returnData, 0x20), returndatasize)\n', '            }\n', '        }\n', '        return abi.decode(returnData, (bytes));\n', '    }\n', '\n', '    function delegateToViewAndReturn() internal view returns (bytes memory) {\n', '        (bool success, ) = address(this).staticcall(abi.encodeWithSignature("delegateToImplementation(bytes)", msg.data));\n', '\n', '        assembly {\n', '            let free_mem_ptr := mload(0x40)\n', '            returndatacopy(free_mem_ptr, 0, returndatasize)\n', '\n', '            switch success\n', '            case 0 { revert(free_mem_ptr, returndatasize) }\n', '            default { return(add(free_mem_ptr, 0x40), returndatasize) }\n', '        }\n', '    }\n', '\n', '    function delegateAndReturn() internal returns (bytes memory) {\n', '        (bool success, ) = implementation.delegatecall(msg.data);\n', '\n', '        assembly {\n', '            let free_mem_ptr := mload(0x40)\n', '            returndatacopy(free_mem_ptr, 0, returndatasize)\n', '\n', '            switch success\n', '            case 0 { revert(free_mem_ptr, returndatasize) }\n', '            default { return(free_mem_ptr, returndatasize) }\n', '        }\n', '    }\n', '}\n', '\n', '// File: contracts\\OptionsPool\\OptionsProxy.sol\n', '\n', 'pragma solidity =0.5.16;\n', '\n', '\n', '/**\n', ' * @title  Erc20Delegator Contract\n', '\n', ' */\n', 'contract OptionsProxy is OptionsData,baseProxy{\n', '        /**\n', '     * @dev constructor function , setting contract address.\n', '     *  oracleAddr FNX oracle contract address\n', '     *  optionsPriceAddr options price contract address\n', '     *  ivAddress implied volatility contract address\n', '     */  \n', '\n', '    constructor(address implementation_,address oracleAddr,address optionsPriceAddr,address ivAddress)\n', '         baseProxy(implementation_) public  {\n', '        _oracle = IFNXOracle(oracleAddr);\n', '        _optionsPrice = IOptionsPrice(optionsPriceAddr);\n', '        _volatility = IVolatility(ivAddress);\n', '    }\n', '    function setTimeLimitation(uint256 /*_limit*/)public{\n', '        delegateAndReturn();\n', '    }\n', '    function getTimeLimitation()public view returns(uint256){\n', '        delegateToViewAndReturn();\n', '    }\n', '    \n', '    /**\n', "     * @dev retrieve user's options' id. \n", "     *  user user's account.\n", '     */     \n', '    function getUserOptionsID(address /*user*/)public view returns(uint64[] memory){\n', '        delegateToViewAndReturn();\n', '    }\n', '    /**\n', "     * @dev retrieve user's `size` number of options' id. \n", "     *  user user's account.\n", "     *  from user's option list begin positon.\n", '     *  size retrieve size.\n', '     */ \n', '    function getUserOptionsID(address /*user*/,uint256 /*from*/,uint256 /*size*/)public view returns(uint64[] memory){\n', '        delegateToViewAndReturn();\n', '    }\n', '    /**\n', '     * @dev retrieve all option list length. \n', '     */ \n', '    function getOptionInfoLength()public view returns (uint256){\n', '        delegateToViewAndReturn();\n', '    }\n', '    /**\n', "     * @dev retrieve `size` number of options' information. \n", '     *  from all option list begin positon.\n', '     *  size retrieve size.\n', '     */     \n', '    function getOptionInfoList(uint256 /*from*/,uint256 /*size*/)public view \n', '                returns(address[] memory,uint256[] memory,uint256[] memory,uint256[] memory,uint256[] memory){\n', '        delegateToViewAndReturn();\n', '    }\n', '    /**\n', "     * @dev retrieve given `ids` options' information. \n", "     *  ids retrieved options' id.\n", '     */   \n', '    function getOptionInfoListFromID(uint256[] memory /*ids*/)public view \n', '                returns(address[] memory,uint256[] memory,uint256[] memory,uint256[] memory,uint256[] memory){\n', '        delegateToViewAndReturn();\n', '    }\n', '    /**\n', "     * @dev retrieve given `optionsId` option's burned limit timestamp. \n", "     *  optionsId retrieved option's id.\n", '     */ \n', '    function getOptionsLimitTimeById(uint256 /*optionsId*/)public view returns(uint256){\n', '        delegateToViewAndReturn();\n', '    }\n', '    /**\n', "     * @dev retrieve given `optionsId` option's information. \n", "     *  optionsId retrieved option's id.\n", '     */ \n', '    function getOptionsById(uint256 /*optionsId*/)public view returns(uint256,address,uint8,uint32,uint256,uint256,uint256){\n', '        delegateToViewAndReturn();\n', '    }\n', '    /**\n', "     * @dev retrieve given `optionsId` option's extra information. \n", "     *  optionsId retrieved option's id.\n", '     */\n', '    function getOptionsExtraById(uint256 /*optionsId*/)public view returns(address,uint256,uint256,uint256,uint256){\n', '        delegateToViewAndReturn();\n', '    }\n', '    /**\n', "     * @dev calculate option's exercise worth.\n", "     *  optionsId option's id\n", "     *  amount option's amount\n", '     */\n', '    function getExerciseWorth(uint256 /*optionsId*/,uint256 /*amount*/)public view returns(uint256){\n', '        delegateToViewAndReturn();\n', '    }\n', '    /**\n', "     * @dev check option's underlying and expiration.\n", "     *  expiration option's expiration\n", "     *  underlying option's underlying\n", '     */\n', '    // function buyOptionCheck(uint32 /*expiration*/,uint32 /*underlying*/)public view{\n', '    //     delegateToViewAndReturn();\n', '    // }\n', '    /**\n', '     * @dev Implementation of add an eligible expiration into the expirationList.\n', '     *  expiration new eligible expiration.\n', '     */\n', '    function addExpiration(uint32 /*expiration*/)public{\n', '        delegateAndReturn();\n', '    }\n', '    /**\n', '     * @dev Implementation of revoke an invalid expiration from the expirationList.\n', '     *  removeExpiration revoked expiration.\n', '     */\n', '    function removeExpirationList(uint32 /*removeExpiration*/)public returns(bool) {\n', '        delegateAndReturn();\n', '    }\n', '    /**\n', '     * @dev Implementation of getting the eligible expirationList.\n', '     */\n', '    function getExpirationList()public view returns (uint32[] memory){\n', '        delegateToViewAndReturn();\n', '    }\n', '    /**\n', '     * @dev Implementation of testing whether the input expiration is eligible.\n', '     *  expiration input expiration for testing.\n', '     */    \n', '    function isEligibleExpiration(uint256 /*expiration*/) public view returns (bool){\n', '        delegateToViewAndReturn();\n', '    }\n', '    /**\n', "     * @dev check option's expiration.\n", "     *  expiration option's expiration\n", '     */\n', '    function checkExpiration(uint256 /*expiration*/) public view{\n', '        delegateToViewAndReturn();\n', '    }\n', '    /**\n', "     * @dev calculate `amount` number of Option's full price when option is burned.\n", "     *  optionID  option's optionID\n", "     *  amount  option's amount\n", '     */\n', '    function getBurnedFullPay(uint256 /*optionID*/,uint256 /*amount*/) public view returns(address,uint256){\n', '        delegateToViewAndReturn();\n', '    }\n', '        /**\n', '     * @dev retrieve collateral occupied calculation information.\n', '     */    \n', '    function getOccupiedCalInfo()public view returns(uint256,int256,int256){\n', '        delegateToViewAndReturn();\n', '    }\n', '    /**\n', '     * @dev calculate collateral occupied value, and modify database, only foundation operator can modify database.\n', '     */  \n', '    function setOccupiedCollateral() public {\n', '        delegateAndReturn();\n', '    }\n', '    /**\n', '     * @dev calculate collateral occupied value.\n', "     *  lastOption last option's position.\n", "     *  beginOption begin option's poisiton.\n", "     *  endOption end option's poisiton.\n", '     */  \n', '    function calculatePhaseOccupiedCollateral(uint256 /*lastOption*/,uint256 /*beginOption*/,uint256 /*endOption*/) public view returns(uint256,uint256,uint256,bool){\n', '        delegateToViewAndReturn();\n', '    }\n', ' \n', '    /**\n', '     * @dev set collateral occupied value, only foundation operator can modify database.\n', '     * totalCallOccupied new call options occupied collateral calculation result.\n', '     * totalPutOccupied new put options occupied collateral calculation result.\n', "     * beginOption new first valid option's positon.\n", "     * latestCallOccpied latest call options' occupied value when operater invoke collateral occupied calculation.\n", "     * latestPutOccpied latest put options' occupied value when operater invoke collateral occupied calculation.\n", '     */  \n', '    function setCollateralPhase(uint256 /*totalCallOccupied*/,uint256 /*totalPutOccupied*/,\n', '        uint256 /*beginOption*/,int256 /*latestCallOccpied*/,int256 /*latestPutOccpied*/) public{\n', '        delegateAndReturn();\n', '    }\n', '    function getAllTotalOccupiedCollateral() public view returns (uint256,uint256){\n', '        delegateToViewAndReturn();\n', '    }\n', '    /**\n', '     * @dev get call options total collateral occupied value.\n', '     */ \n', '    function getCallTotalOccupiedCollateral() public view returns (uint256) {\n', '        delegateToViewAndReturn();\n', '    }\n', '    /**\n', '     * @dev get put options total collateral occupied value.\n', '     */ \n', '    function getPutTotalOccupiedCollateral() public view returns (uint256) {\n', '        delegateToViewAndReturn();\n', '    }\n', '    /**\n', '     * @dev get real total collateral occupied value.\n', '     */ \n', '    function getTotalOccupiedCollateral() public view returns (uint256) {\n', '        delegateToViewAndReturn();\n', '    }\n', '    /**\n', '     * @dev retrieve all information for net worth calculation. \n', '     *  whiteList collateral address whitelist.\n', '     */ \n', '    function getNetWrothCalInfo(address[] memory /*whiteList*/)public view returns(uint256,int256[] memory){\n', '        delegateToViewAndReturn();\n', '    }\n', '    /**\n', '     * @dev retrieve latest options net worth which paid in settlement coin. \n', '     *  settlement settlement coin address.\n', '     */ \n', '    function getNetWrothLatestWorth(address /*settlement*/)public view returns(int256){\n', '        delegateToViewAndReturn();\n', '    }\n', '    /**\n', '     * @dev set latest options net worth balance, only manager contract can modify database.\n', '     *  newFirstOption new first valid option position.\n', '     *  latestNetWorth latest options net worth.\n', '     *  whiteList eligible collateral address white list.\n', '     */ \n', '    function setSharedState(uint256 /*newFirstOption*/,int256[] memory /*latestNetWorth*/,address[] memory /*whiteList*/) public{\n', '        delegateAndReturn();\n', '    }\n', '    /**\n', '     * @dev calculate options time shared value,from begin to end in the alloptionsList.\n', '     *  lastOption the last option position.\n', '     *  begin the begin options position.\n', '     *  end the end options position.\n', '     *  whiteList eligible collateral address white list.\n', '     */\n', '    function calRangeSharedPayment(uint256 /*lastOption*/,uint256 /*begin*/,uint256 /*end*/,address[] memory /*whiteList*/)\n', '            public view returns(int256[] memory,uint256[] memory,uint256){\n', '        delegateToViewAndReturn();\n', '    }\n', '    /**\n', '     * @dev calculate options payback fall value,from begin to end in the alloptionsList.\n', '     *  lastOption the last option position.\n', '     *  begin the begin options position.\n', '     *  end the end options position.\n', '     *  whiteList eligible collateral address white list.\n', '     */\n', '    function calculatePhaseOptionsFall(uint256 /*lastOption*/,uint256 /*begin*/,uint256 /*end*/,address[] memory /*whiteList*/) public view returns(int256[] memory){\n', '        delegateToViewAndReturn();\n', '    }\n', '\n', '    /**\n', '     * @dev retrieve all information for collateral occupied and net worth calculation.\n', '     *  whiteList settlement address whitelist.\n', '     */ \n', '    function getOptionCalRangeAll(address[] memory /*whiteList*/)public view returns(uint256,int256,int256,uint256,int256[] memory,uint256,uint256){\n', '        delegateToViewAndReturn();\n', '    }\n', '    /**\n', '     * @dev create new option,modify collateral occupied and net worth value, only manager contract can invoke this.\n', "     *  from user's address.\n", "     *  settlement user's input settlement coin.\n", '     *  type_ly_exp tuple64 for option type,underlying,expiration.\n', "     *  strikePrice user's input new option's strike price.\n", "     *  optionPrice current new option's price, calculated by options price contract.\n", "     *  amount user's input new option's amount.\n", '     */ \n', '    function createOptions(address /*from*/,address /*settlement*/,uint256 /*type_ly_exp*/,\n', '    uint128 /*strikePrice*/,uint128 /*underlyingPrice*/,uint128 /*amount*/,uint128 /*settlePrice*/) public returns(uint256) {\n', '        delegateAndReturn();\n', '    }\n', '    /**\n', '     * @dev burn option,modify collateral occupied and net worth value, only manager contract can invoke this.\n', "     *  from user's address.\n", "     *  id user's input option's id.\n", "     *  amount user's input burned option's amount.\n", "     *  optionPrice current new option's price, calculated by options price contract.\n", '     */ \n', '    function burnOptions(address /*from*/,uint256 /*id*/,uint256 /*amount*/,uint256 /*optionPrice*/)public{\n', '        delegateAndReturn();\n', '    }\n', '    function getUserAllOptionInfo(address /*user*/)public view \n', '        returns(address[] memory,uint256[] memory,uint256[] memory,uint256[] memory,uint256[] memory){\n', '        delegateToViewAndReturn();\n', '    }\n', '}']