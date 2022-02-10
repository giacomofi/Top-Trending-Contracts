['pragma solidity ^0.4.24;\n', '\n', '// File: contracts/lib/ownership/Ownable.sol\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '    event OwnershipTransferred(address indexed previousOwner,address indexed newOwner);\n', '\n', '    /// @dev The Ownable constructor sets the original `owner` of the contract to the sender account.\n', '    constructor() public { owner = msg.sender; }\n', '\n', '    /// @dev Throws if called by any contract other than latest designated caller\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /// @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '    /// @param newOwner The address to transfer ownership to.\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '       require(newOwner != address(0));\n', '       emit OwnershipTransferred(owner, newOwner);\n', '       owner = newOwner;\n', '    }\n', '}\n', '\n', '// File: contracts/lib/lifecycle/Destructible.sol\n', '\n', 'contract Destructible is Ownable {\n', '\tfunction selfDestruct() public onlyOwner {\n', '\t\tselfdestruct(owner);\n', '\t}\n', '}\n', '\n', '// File: contracts/lib/ownership/ZapCoordinatorInterface.sol\n', '\n', 'contract ZapCoordinatorInterface is Ownable {\n', '\tfunction addImmutableContract(string contractName, address newAddress) external;\n', '\tfunction updateContract(string contractName, address newAddress) external;\n', '\tfunction getContractName(uint index) public view returns (string);\n', '\tfunction getContract(string contractName) public view returns (address);\n', '\tfunction updateAllDependencies() external;\n', '}\n', '\n', '// File: contracts/lib/ownership/Upgradable.sol\n', '\n', 'pragma solidity ^0.4.24;\n', '\n', 'contract Upgradable {\n', '\n', '\taddress coordinatorAddr;\n', '\tZapCoordinatorInterface coordinator;\n', '\n', '\tconstructor(address c) public{\n', '\t\tcoordinatorAddr = c;\n', '\t\tcoordinator = ZapCoordinatorInterface(c);\n', '\t}\n', '\n', '    function updateDependencies() external coordinatorOnly {\n', '       _updateDependencies();\n', '    }\n', '\n', '    function _updateDependencies() internal;\n', '\n', '    modifier coordinatorOnly() {\n', '    \trequire(msg.sender == coordinatorAddr, "Error: Coordinator Only Function");\n', '    \t_;\n', '    }\n', '}\n', '\n', '// File: contracts/lib/ERC20.sol\n', '\n', 'contract ERC20Basic {\n', '    uint256 public totalSupply;\n', '    function balanceOf(address who) public constant returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '    string public name;\n', '    string public symbol;\n', '    uint256 public decimals;\n', '    function allowance(address owner, address spender) public constant returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '// File: contracts/platform/database/DatabaseInterface.sol\n', '\n', 'contract DatabaseInterface is Ownable {\n', '\tfunction setStorageContract(address _storageContract, bool _allowed) public;\n', '\t/*** Bytes32 ***/\n', '\tfunction getBytes32(bytes32 key) external view returns(bytes32);\n', '\tfunction setBytes32(bytes32 key, bytes32 value) external;\n', '\t/*** Number **/\n', '\tfunction getNumber(bytes32 key) external view returns(uint256);\n', '\tfunction setNumber(bytes32 key, uint256 value) external;\n', '\t/*** Bytes ***/\n', '\tfunction getBytes(bytes32 key) external view returns(bytes);\n', '\tfunction setBytes(bytes32 key, bytes value) external;\n', '\t/*** String ***/\n', '\tfunction getString(bytes32 key) external view returns(string);\n', '\tfunction setString(bytes32 key, string value) external;\n', '\t/*** Bytes Array ***/\n', '\tfunction getBytesArray(bytes32 key) external view returns (bytes32[]);\n', '\tfunction getBytesArrayIndex(bytes32 key, uint256 index) external view returns (bytes32);\n', '\tfunction getBytesArrayLength(bytes32 key) external view returns (uint256);\n', '\tfunction pushBytesArray(bytes32 key, bytes32 value) external;\n', '\tfunction setBytesArrayIndex(bytes32 key, uint256 index, bytes32 value) external;\n', '\tfunction setBytesArray(bytes32 key, bytes32[] value) external;\n', '\t/*** Int Array ***/\n', '\tfunction getIntArray(bytes32 key) external view returns (int[]);\n', '\tfunction getIntArrayIndex(bytes32 key, uint256 index) external view returns (int);\n', '\tfunction getIntArrayLength(bytes32 key) external view returns (uint256);\n', '\tfunction pushIntArray(bytes32 key, int value) external;\n', '\tfunction setIntArrayIndex(bytes32 key, uint256 index, int value) external;\n', '\tfunction setIntArray(bytes32 key, int[] value) external;\n', '\t/*** Address Array ***/\n', '\tfunction getAddressArray(bytes32 key) external view returns (address[]);\n', '\tfunction getAddressArrayIndex(bytes32 key, uint256 index) external view returns (address);\n', '\tfunction getAddressArrayLength(bytes32 key) external view returns (uint256);\n', '\tfunction pushAddressArray(bytes32 key, address value) external;\n', '\tfunction setAddressArrayIndex(bytes32 key, uint256 index, address value) external;\n', '\tfunction setAddressArray(bytes32 key, address[] value) external;\n', '}\n', '\n', '// File: contracts/platform/bondage/currentCost/CurrentCostInterface.sol\n', '\n', 'contract CurrentCostInterface {    \n', '    function _currentCostOfDot(address, bytes32, uint256) public view returns (uint256);\n', '    function _dotLimit(address, bytes32) public view returns (uint256);\n', '    function _costOfNDots(address, bytes32, uint256, uint256) public view returns (uint256);\n', '}\n', '\n', '// File: contracts/platform/bondage/BondageInterface.sol\n', '\n', 'contract BondageInterface {\n', '    function bond(address, bytes32, uint256) external returns(uint256);\n', '    function unbond(address, bytes32, uint256) external returns (uint256);\n', '    function delegateBond(address, address, bytes32, uint256) external returns(uint256);\n', '    function escrowDots(address, address, bytes32, uint256) external returns (bool);\n', '    function releaseDots(address, address, bytes32, uint256) external returns (bool);\n', '    function returnDots(address, address, bytes32, uint256) external returns (bool success);\n', '    function calcZapForDots(address, bytes32, uint256) external view returns (uint256);\n', '    function currentCostOfDot(address, bytes32, uint256) public view returns (uint256);\n', '    function getDotsIssued(address, bytes32) public view returns (uint256);\n', '    function getBoundDots(address, address, bytes32) public view returns (uint256);\n', '    function getZapBound(address, bytes32) public view returns (uint256);\n', '    function dotLimit( address, bytes32) public view returns (uint256);\n', '}\n', '\n', '// File: contracts/platform/bondage/Bondage.sol\n', '\n', 'contract Bondage is Destructible, BondageInterface, Upgradable {\n', '    DatabaseInterface public db;\n', '\n', '    event Bound(address indexed holder, address indexed oracle, bytes32 indexed endpoint, uint256 numZap, uint256 numDots);\n', '    event Unbound(address indexed holder, address indexed oracle, bytes32 indexed endpoint, uint256 numDots);\n', '    event Escrowed(address indexed holder, address indexed oracle, bytes32 indexed endpoint, uint256 numDots);\n', '    event Released(address indexed holder, address indexed oracle, bytes32 indexed endpoint, uint256 numDots);\n', '    event Returned(address indexed holder, address indexed oracle, bytes32 indexed endpoint, uint256 numDots);\n', '\n', '\n', '    CurrentCostInterface currentCost;\n', '    ERC20 token;\n', '\n', '    address public arbiterAddress;\n', '    address public dispatchAddress;\n', '\n', '    // For restricting dot escrow/transfer method calls to Dispatch and Arbiter\n', '    modifier operatorOnly() {\n', '        require(msg.sender == arbiterAddress || msg.sender == dispatchAddress, "Error: Operator Only Error");\n', '        _;\n', '    }\n', '\n', '    /// @dev Initialize Storage, Token, anc CurrentCost Contracts\n', '    constructor(address c) Upgradable(c) public {\n', '        _updateDependencies();\n', '    }\n', '\n', '    function _updateDependencies() internal {\n', '        address databaseAddress = coordinator.getContract("DATABASE");\n', '        db = DatabaseInterface(databaseAddress);\n', '        arbiterAddress = coordinator.getContract("ARBITER");\n', '        dispatchAddress = coordinator.getContract("DISPATCH");\n', '        token = ERC20(coordinator.getContract("ZAP_TOKEN")); \n', '        currentCost = CurrentCostInterface(coordinator.getContract("CURRENT_COST")); \n', '    }\n', '\n', '    /// @dev will bond to an oracle\n', '    /// @return total ZAP bound to oracle\n', '    function bond(address oracleAddress, bytes32 endpoint, uint256 numDots) external returns (uint256 bound) {\n', '        bound = _bond(msg.sender, oracleAddress, endpoint, numDots);\n', '        emit Bound(msg.sender, oracleAddress, endpoint, bound, numDots);\n', '    }\n', '\n', '    /// @return total ZAP unbound from oracle\n', '    function unbond(address oracleAddress, bytes32 endpoint, uint256 numDots) external returns (uint256 unbound) {\n', '        unbound = _unbond(msg.sender, oracleAddress, endpoint, numDots);\n', '        emit Unbound(msg.sender, oracleAddress, endpoint, numDots);\n', '    }        \n', '\n', '    /// @dev will bond to an oracle on behalf of some holder\n', '    /// @return total ZAP bound to oracle\n', '    function delegateBond(address holderAddress, address oracleAddress, bytes32 endpoint, uint256 numDots) external returns (uint256 boundZap) {\n', '        boundZap = _bond(holderAddress, oracleAddress, endpoint, numDots);\n', '        emit Bound(holderAddress, oracleAddress, endpoint, boundZap, numDots);\n', '    }\n', '\n', '    /// @dev Move numDots dots from provider-requester to bondage according to \n', "    /// data-provider address, holder address, and endpoint specifier (ala 'smart_contract')\n", '    /// Called only by Dispatch or Arbiter Contracts\n', '    function escrowDots(        \n', '        address holderAddress,\n', '        address oracleAddress,\n', '        bytes32 endpoint,\n', '        uint256 numDots\n', '    )\n', '        external\n', '        operatorOnly        \n', '        returns (bool success)\n', '    {\n', '        uint256 boundDots = getBoundDots(holderAddress, oracleAddress, endpoint);\n', '        require(numDots <= boundDots, "Error: Not enough dots bound");\n', '        updateEscrow(holderAddress, oracleAddress, endpoint, numDots, "add");\n', '        updateBondValue(holderAddress, oracleAddress, endpoint, numDots, "sub");\n', '        emit Escrowed(holderAddress, oracleAddress, endpoint, numDots);\n', '        return true;\n', '    }\n', '\n', '    /// @dev Transfer N dots from fromAddress to destAddress. \n', '    /// Called only by Disptach or Arbiter Contracts\n', '    /// In smart contract endpoint, occurs per satisfied request. \n', '    /// In socket endpoint called on termination of subscription.\n', '    function releaseDots(\n', '        address holderAddress,\n', '        address oracleAddress,\n', '        bytes32 endpoint,\n', '        uint256 numDots\n', '    )\n', '        external\n', '        operatorOnly \n', '        returns (bool success)\n', '    {\n', '        uint256 numEscrowed = getNumEscrow(holderAddress, oracleAddress, endpoint);\n', '        require(numDots <= numEscrowed, "Error: Not enough dots Escrowed");\n', '        updateEscrow(holderAddress, oracleAddress, endpoint, numDots, "sub");\n', '        updateBondValue(oracleAddress, oracleAddress, endpoint, numDots, "add");\n', '        emit Released(holderAddress, oracleAddress, endpoint, numDots);\n', '        return true;\n', '    }\n', '\n', '    /// @dev Transfer N dots from destAddress to fromAddress. \n', '    /// Called only by Disptach or Arbiter Contracts\n', '    /// In smart contract endpoint, occurs per satisfied request. \n', '    /// In socket endpoint called on termination of subscription.\n', '    function returnDots(\n', '        address holderAddress,\n', '        address oracleAddress,\n', '        bytes32 endpoint,\n', '        uint256 numDots\n', '    )\n', '        external\n', '        operatorOnly \n', '        returns (bool success)\n', '    {\n', '        uint256 numEscrowed = getNumEscrow(holderAddress, oracleAddress, endpoint);\n', '        require(numDots <= numEscrowed, "Error: Not enough dots escrowed");\n', '        updateEscrow(holderAddress, oracleAddress, endpoint, numDots, "sub");\n', '        updateBondValue(holderAddress, oracleAddress, endpoint, numDots, "add");\n', '        emit Returned(holderAddress, oracleAddress, endpoint, numDots);\n', '        return true;\n', '    }\n', '\n', '\n', '    /// @dev Calculate quantity of tokens required for specified amount of dots\n', '    /// for endpoint defined by endpoint and data provider defined by oracleAddress\n', '    function calcZapForDots(\n', '        address oracleAddress,\n', '        bytes32 endpoint,\n', '        uint256 numDots       \n', '    ) \n', '        external\n', '        view\n', '        returns (uint256 numZap)\n', '    {\n', '        uint256 issued = getDotsIssued(oracleAddress, endpoint);\n', '        return currentCost._costOfNDots(oracleAddress, endpoint, issued + 1, numDots - 1);\n', '    }\n', '\n', '    /// @dev Get the current cost of a dot.\n', '    /// @param endpoint specifier\n', '    /// @param oracleAddress data-provider\n', '    /// @param totalBound current number of dots\n', '    function currentCostOfDot(\n', '        address oracleAddress,\n', '        bytes32 endpoint,\n', '        uint256 totalBound\n', '    )\n', '        public\n', '        view\n', '        returns (uint256 cost)\n', '    {\n', '        return currentCost._currentCostOfDot(oracleAddress, endpoint, totalBound);\n', '    }\n', '\n', '    /// @dev Get issuance limit of dots \n', '    /// @param endpoint specifier\n', '    /// @param oracleAddress data-provider\n', '    function dotLimit(\n', '        address oracleAddress,\n', '        bytes32 endpoint\n', '    )\n', '        public\n', '        view\n', '        returns (uint256 limit)\n', '    {\n', '        return currentCost._dotLimit(oracleAddress, endpoint);\n', '    }\n', '\n', '\n', '    /// @return total ZAP held by contract\n', '    function getZapBound(address oracleAddress, bytes32 endpoint) public view returns (uint256) {\n', '        return getNumZap(oracleAddress, endpoint);\n', '    }\n', '\n', '    function _bond(\n', '        address holderAddress,\n', '        address oracleAddress,\n', '        bytes32 endpoint,\n', '        uint256 numDots        \n', '    )\n', '        private\n', '        returns (uint256) \n', '    {   \n', '\n', '        address broker = getEndpointBroker(oracleAddress, endpoint);\n', '\n', '        if( broker != address(0)){\n', '            require(msg.sender == broker, "Error: Only the broker has access to this function");\n', '        }\n', '\n', '        // This also checks if oracle is registered w/an initialized curve\n', '        uint256 issued = getDotsIssued(oracleAddress, endpoint);\n', '        require(issued + numDots <= dotLimit(oracleAddress, endpoint), "Error: Dot limit exceeded");\n', '        \n', '        uint256 numZap = currentCost._costOfNDots(oracleAddress, endpoint, issued + 1, numDots - 1);\n', '\n', '        // User must have approved contract to transfer working ZAP\n', '        require(token.transferFrom(msg.sender, this, numZap), "Error: User must have approved contract to transfer ZAP");\n', '\n', '        if (!isProviderInitialized(holderAddress, oracleAddress)) {            \n', '            setProviderInitialized(holderAddress, oracleAddress);\n', '            addHolderOracle(holderAddress, oracleAddress);\n', '        }\n', '\n', '        updateBondValue(holderAddress, oracleAddress, endpoint, numDots, "add");        \n', '        updateTotalIssued(oracleAddress, endpoint, numDots, "add");\n', '        updateTotalBound(oracleAddress, endpoint, numZap, "add");\n', '\n', '        return numZap;\n', '    }\n', '\n', '    function _unbond(        \n', '        address holderAddress,\n', '        address oracleAddress,\n', '        bytes32 endpoint,\n', '        uint256 numDots\n', '    )\n', '        private\n', '        returns (uint256 numZap)\n', '    {\n', '        address broker = getEndpointBroker(oracleAddress, endpoint);\n', '\n', '        if( broker != address(0)){\n', '            require(msg.sender == broker, "Error: Only the broker has access to this function");\n', '        }\n', '\n', '        // Make sure the user has enough to bond with some additional sanity checks\n', '        uint256 amountBound = getBoundDots(holderAddress, oracleAddress, endpoint);\n', '        require(amountBound >= numDots, "Error: Not enough dots bonded");\n', '        require(numDots > 0, "Error: Dots to unbond must be more than zero");\n', '\n', '        // Get the value of the dots\n', '        uint256 issued = getDotsIssued(oracleAddress, endpoint);\n', '        numZap = currentCost._costOfNDots(oracleAddress, endpoint, issued + 1 - numDots, numDots - 1);\n', '\n', '        // Update the storage values\n', '        updateTotalBound(oracleAddress, endpoint, numZap, "sub");\n', '        updateTotalIssued(oracleAddress, endpoint, numDots, "sub");\n', '        updateBondValue(holderAddress, oracleAddress, endpoint, numDots, "sub");\n', '\n', '        // Do the transfer\n', '        require(token.transfer(msg.sender, numZap), "Error: Transfer failed");\n', '\n', '        return numZap;\n', '    }\n', '\n', '    /**** Get Methods ****/\n', '    function isProviderInitialized(address holderAddress, address oracleAddress) public view returns (bool) {\n', "        return db.getNumber(keccak256(abi.encodePacked('holders', holderAddress, 'initialized', oracleAddress))) == 1 ? true : false;\n", '    }\n', '\n', '    /// @dev get broker address for endpoint\n', '    function getEndpointBroker(address oracleAddress, bytes32 endpoint) public view returns (address) {\n', "        return address(db.getBytes32(keccak256(abi.encodePacked('oracles', oracleAddress, endpoint, 'broker'))));\n", '    }\n', '\n', '    function getNumEscrow(address holderAddress, address oracleAddress, bytes32 endpoint) public view returns (uint256) {\n', "        return db.getNumber(keccak256(abi.encodePacked('escrow', holderAddress, oracleAddress, endpoint)));\n", '    }\n', '\n', '    function getNumZap(address oracleAddress, bytes32 endpoint) public view returns (uint256) {\n', "        return db.getNumber(keccak256(abi.encodePacked('totalBound', oracleAddress, endpoint)));\n", '    }\n', '\n', '    function getDotsIssued(address oracleAddress, bytes32 endpoint) public view returns (uint256) {\n', "        return db.getNumber(keccak256(abi.encodePacked('totalIssued', oracleAddress, endpoint)));\n", '    }\n', '\n', '    function getBoundDots(address holderAddress, address oracleAddress, bytes32 endpoint) public view returns (uint256) {\n', "        return db.getNumber(keccak256(abi.encodePacked('holders', holderAddress, 'bonds', oracleAddress, endpoint)));\n", '    }\n', '\n', '    function getIndexSize(address holderAddress) external view returns (uint256) {\n', "        return db.getAddressArrayLength(keccak256(abi.encodePacked('holders', holderAddress, 'oracleList')));\n", '    }\n', '\n', '    function getOracleAddress(address holderAddress, uint256 index) public view returns (address) {\n', "        return db.getAddressArrayIndex(keccak256(abi.encodePacked('holders', holderAddress, 'oracleList')), index);\n", '    }\n', '\n', '    /**** Set Methods ****/\n', '    function addHolderOracle(address holderAddress, address oracleAddress) internal {\n', "        db.pushAddressArray(keccak256(abi.encodePacked('holders', holderAddress, 'oracleList')), oracleAddress);\n", '    }\n', '\n', '    function setProviderInitialized(address holderAddress, address oracleAddress) internal {\n', "        db.setNumber(keccak256(abi.encodePacked('holders', holderAddress, 'initialized', oracleAddress)), 1);\n", '    }\n', '\n', '    function updateEscrow(address holderAddress, address oracleAddress, bytes32 endpoint, uint256 numDots, bytes32 op) internal {\n', "        uint256 newEscrow = db.getNumber(keccak256(abi.encodePacked('escrow', holderAddress, oracleAddress, endpoint)));\n", '\n', '        if ( op == "sub" ) {\n', '            newEscrow -= numDots;\n', '        } else if ( op == "add" ) {\n', '            newEscrow += numDots;\n', '        }\n', '        else {\n', '            revert();\n', '        }\n', '\n', "        db.setNumber(keccak256(abi.encodePacked('escrow', holderAddress, oracleAddress, endpoint)), newEscrow);\n", '    }\n', '\n', '    function updateBondValue(address holderAddress, address oracleAddress, bytes32 endpoint, uint256 numDots, bytes32 op) internal {\n', "        uint256 bondValue = db.getNumber(keccak256(abi.encodePacked('holders', holderAddress, 'bonds', oracleAddress, endpoint)));\n", '        \n', '        if (op == "sub") {\n', '            bondValue -= numDots;\n', '        } else if (op == "add") {\n', '            bondValue += numDots;\n', '        }\n', '\n', "        db.setNumber(keccak256(abi.encodePacked('holders', holderAddress, 'bonds', oracleAddress, endpoint)), bondValue);\n", '    }\n', '\n', '    function updateTotalBound(address oracleAddress, bytes32 endpoint, uint256 numZap, bytes32 op) internal {\n', "        uint256 totalBound = db.getNumber(keccak256(abi.encodePacked('totalBound', oracleAddress, endpoint)));\n", '        \n', '        if (op == "sub"){\n', '            totalBound -= numZap;\n', '        } else if (op == "add") {\n', '            totalBound += numZap;\n', '        }\n', '        else {\n', '            revert();\n', '        }\n', '        \n', "        db.setNumber(keccak256(abi.encodePacked('totalBound', oracleAddress, endpoint)), totalBound);\n", '    }\n', '\n', '    function updateTotalIssued(address oracleAddress, bytes32 endpoint, uint256 numDots, bytes32 op) internal {\n', "        uint256 totalIssued = db.getNumber(keccak256(abi.encodePacked('totalIssued', oracleAddress, endpoint)));\n", '        \n', '        if (op == "sub"){\n', '            totalIssued -= numDots;\n', '        } else if (op == "add") {\n', '            totalIssued += numDots;\n', '        }\n', '        else {\n', '            revert();\n', '        }\n', '    \n', "        db.setNumber(keccak256(abi.encodePacked('totalIssued', oracleAddress, endpoint)), totalIssued);\n", '    }\n', '}\n', '\n', '    /*************************************** STORAGE ****************************************\n', "    * 'holders', holderAddress, 'initialized', oracleAddress => {uint256} 1 -> provider-subscriber initialized, 0 -> not initialized \n", "    * 'holders', holderAddress, 'bonds', oracleAddress, endpoint => {uint256} number of dots this address has bound to this endpoint\n", "    * 'oracles', oracleAddress, endpoint, 'broker' => {address} address of endpoint broker, 0 if none\n", "    * 'escrow', holderAddress, oracleAddress, endpoint => {uint256} amount of Zap that have been escrowed\n", "    * 'totalBound', oracleAddress, endpoint => {uint256} amount of Zap bound to this endpoint\n", "    * 'totalIssued', oracleAddress, endpoint => {uint256} number of dots issued by this endpoint\n", "    * 'holders', holderAddress, 'oracleList' => {address[]} array of oracle addresses associated with this holder\n", '    ****************************************************************************************/']