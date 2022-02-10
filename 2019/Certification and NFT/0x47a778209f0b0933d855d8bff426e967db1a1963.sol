['/**\n', ' *Submitted for verification at Etherscan.io on 2019-07-09\n', '*/\n', '\n', 'pragma solidity ^0.4.23;\n', '\n', 'pragma solidity ^0.4.23;\n', '\n', 'pragma solidity ^0.4.23;\n', '\n', 'pragma solidity ^0.4.23;\n', '\n', '\n', 'pragma solidity ^0.4.23;\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    emit Pause();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    emit Unpause();\n', '  }\n', '}\n', '\n', 'pragma solidity ^0.4.23;\n', '\n', '/// @author https://BlockChainArchitect.iocontract Bank is CutiePluginBase\n', 'contract PluginInterface\n', '{\n', '    /// @dev simply a boolean to indicate this is the contract we expect to be\n', '    function isPluginInterface() public pure returns (bool);\n', '\n', '    function onRemove() public;\n', '\n', '    /// @dev Begins new feature.\n', '    /// @param _cutieId - ID of token to auction, sender must be owner.\n', '    /// @param _parameter - arbitrary parameter\n', '    /// @param _seller - Old owner, if not the message sender\n', '    function run(\n', '        uint40 _cutieId,\n', '        uint256 _parameter,\n', '        address _seller\n', '    )\n', '    public\n', '    payable;\n', '\n', '    /// @dev Begins new feature, approved and signed by COO.\n', '    /// @param _cutieId - ID of token to auction, sender must be owner.\n', '    /// @param _parameter - arbitrary parameter\n', '    function runSigned(\n', '        uint40 _cutieId,\n', '        uint256 _parameter,\n', '        address _owner\n', '    ) external payable;\n', '\n', '    function withdraw() external;\n', '}\n', '\n', 'pragma solidity ^0.4.23;\n', '\n', 'pragma solidity ^0.4.23;\n', '\n', '/// @title BlockchainCuties: Collectible and breedable cuties on the Ethereum blockchain.\n', '/// @author https://BlockChainArchitect.io\n', '/// @dev This is the BlockchainCuties configuration. It can be changed redeploying another version.\n', 'interface ConfigInterface\n', '{\n', '    function isConfig() external pure returns (bool);\n', '\n', '    function getCooldownIndexFromGeneration(uint16 _generation, uint40 _cutieId) external view returns (uint16);\n', '    function getCooldownEndTimeFromIndex(uint16 _cooldownIndex, uint40 _cutieId) external view returns (uint40);\n', '    function getCooldownIndexFromGeneration(uint16 _generation) external view returns (uint16);\n', '    function getCooldownEndTimeFromIndex(uint16 _cooldownIndex) external view returns (uint40);\n', '\n', '    function getCooldownIndexCount() external view returns (uint256);\n', '\n', '    function getBabyGenFromId(uint40 _momId, uint40 _dadId) external view returns (uint16);\n', '    function getBabyGen(uint16 _momGen, uint16 _dadGen) external pure returns (uint16);\n', '\n', '    function getTutorialBabyGen(uint16 _dadGen) external pure returns (uint16);\n', '\n', '    function getBreedingFee(uint40 _momId, uint40 _dadId) external view returns (uint256);\n', '}\n', '\n', '\n', 'contract CutieCoreInterface\n', '{\n', '    function isCutieCore() pure public returns (bool);\n', '\n', '    ConfigInterface public config;\n', '\n', '    function transferFrom(address _from, address _to, uint256 _cutieId) external;\n', '    function transfer(address _to, uint256 _cutieId) external;\n', '\n', '    function ownerOf(uint256 _cutieId)\n', '        external\n', '        view\n', '        returns (address owner);\n', '\n', '    function getCutie(uint40 _id)\n', '        external\n', '        view\n', '        returns (\n', '        uint256 genes,\n', '        uint40 birthTime,\n', '        uint40 cooldownEndTime,\n', '        uint40 momId,\n', '        uint40 dadId,\n', '        uint16 cooldownIndex,\n', '        uint16 generation\n', '    );\n', '\n', '    function getGenes(uint40 _id)\n', '        public\n', '        view\n', '        returns (\n', '        uint256 genes\n', '    );\n', '\n', '\n', '    function getCooldownEndTime(uint40 _id)\n', '        public\n', '        view\n', '        returns (\n', '        uint40 cooldownEndTime\n', '    );\n', '\n', '    function getCooldownIndex(uint40 _id)\n', '        public\n', '        view\n', '        returns (\n', '        uint16 cooldownIndex\n', '    );\n', '\n', '\n', '    function getGeneration(uint40 _id)\n', '        public\n', '        view\n', '        returns (\n', '        uint16 generation\n', '    );\n', '\n', '    function getOptional(uint40 _id)\n', '        public\n', '        view\n', '        returns (\n', '        uint64 optional\n', '    );\n', '\n', '\n', '    function changeGenes(\n', '        uint40 _cutieId,\n', '        uint256 _genes)\n', '        public;\n', '\n', '    function changeCooldownEndTime(\n', '        uint40 _cutieId,\n', '        uint40 _cooldownEndTime)\n', '        public;\n', '\n', '    function changeCooldownIndex(\n', '        uint40 _cutieId,\n', '        uint16 _cooldownIndex)\n', '        public;\n', '\n', '    function changeOptional(\n', '        uint40 _cutieId,\n', '        uint64 _optional)\n', '        public;\n', '\n', '    function changeGeneration(\n', '        uint40 _cutieId,\n', '        uint16 _generation)\n', '        public;\n', '\n', '    function createSaleAuction(\n', '        uint40 _cutieId,\n', '        uint128 _startPrice,\n', '        uint128 _endPrice,\n', '        uint40 _duration\n', '    )\n', '    public;\n', '\n', '    function getApproved(uint256 _tokenId) external returns (address);\n', '    function totalSupply() view external returns (uint256);\n', '    function createPromoCutie(uint256 _genes, address _owner) external;\n', '    function checkOwnerAndApprove(address _claimant, uint40 _cutieId, address _pluginsContract) external view;\n', '    function breedWith(uint40 _momId, uint40 _dadId) public payable returns (uint40);\n', '    function getBreedingFee(uint40 _momId, uint40 _dadId) public view returns (uint256);\n', '    function restoreCutieToAddress(uint40 _cutieId, address _recipient) external;\n', '    function createGen0Auction(uint256 _genes, uint128 startPrice, uint128 endPrice, uint40 duration) external;\n', '    function createGen0AuctionWithTokens(uint256 _genes, uint128 startPrice, uint128 endPrice, uint40 duration, address[] allowedTokens) external;\n', '    function createPromoCutieWithGeneration(uint256 _genes, address _owner, uint16 _generation) external;\n', '    function createPromoCutieBulk(uint256[] _genes, address _owner, uint16 _generation) external;\n', '}\n', '\n', 'pragma solidity ^0.4.23;\n', '\n', '\n', 'pragma solidity ^0.4.23;\n', '\n', 'contract Operators\n', '{\n', '    mapping (address=>bool) ownerAddress;\n', '    mapping (address=>bool) operatorAddress;\n', '\n', '    constructor() public\n', '    {\n', '        ownerAddress[msg.sender] = true;\n', '    }\n', '\n', '    modifier onlyOwner()\n', '    {\n', '        require(ownerAddress[msg.sender]);\n', '        _;\n', '    }\n', '\n', '    function isOwner(address _addr) public view returns (bool) {\n', '        return ownerAddress[_addr];\n', '    }\n', '\n', '    function addOwner(address _newOwner) external onlyOwner {\n', '        require(_newOwner != address(0));\n', '\n', '        ownerAddress[_newOwner] = true;\n', '    }\n', '\n', '    function removeOwner(address _oldOwner) external onlyOwner {\n', '        delete(ownerAddress[_oldOwner]);\n', '    }\n', '\n', '    modifier onlyOperator() {\n', '        require(isOperator(msg.sender));\n', '        _;\n', '    }\n', '\n', '    function isOperator(address _addr) public view returns (bool) {\n', '        return operatorAddress[_addr] || ownerAddress[_addr];\n', '    }\n', '\n', '    function addOperator(address _newOperator) external onlyOwner {\n', '        require(_newOperator != address(0));\n', '\n', '        operatorAddress[_newOperator] = true;\n', '    }\n', '\n', '    function removeOperator(address _oldOperator) external onlyOwner {\n', '        delete(operatorAddress[_oldOperator]);\n', '    }\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract PausableOperators is Operators {\n', '    event Pause();\n', '    event Unpause();\n', '\n', '    bool public paused = false;\n', '\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable only when the contract is not paused.\n', '     */\n', '    modifier whenNotPaused() {\n', '        require(!paused);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable only when the contract is paused.\n', '     */\n', '    modifier whenPaused() {\n', '        require(paused);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev called by the owner to pause, triggers stopped state\n', '     */\n', '    function pause() onlyOwner whenNotPaused public {\n', '        paused = true;\n', '        emit Pause();\n', '    }\n', '\n', '    /**\n', '     * @dev called by the owner to unpause, returns to normal state\n', '     */\n', '    function unpause() onlyOwner whenPaused public {\n', '        paused = false;\n', '        emit Unpause();\n', '    }\n', '}\n', '\n', '\n', '/// @author https://BlockChainArchitect.iocontract Bank is CutiePluginBase\n', 'contract CutiePluginBase is PluginInterface, PausableOperators\n', '{\n', '    function isPluginInterface() public pure returns (bool)\n', '    {\n', '        return true;\n', '    }\n', '\n', '    // Reference to contract tracking NFT ownership\n', '    CutieCoreInterface public coreContract;\n', '    address public pluginsContract;\n', '\n', '    // @dev Throws if called by any account other than the owner.\n', '    modifier onlyCore() {\n', '        require(msg.sender == address(coreContract));\n', '        _;\n', '    }\n', '\n', '    modifier onlyPlugins() {\n', '        require(msg.sender == pluginsContract);\n', '        _;\n', '    }\n', '\n', '    /// @dev Constructor creates a reference to the NFT ownership contract\n', '    ///  and verifies the owner cut is in the valid range.\n', '    /// @param _coreAddress - address of a deployed contract implementing\n', '    ///  the Nonfungible Interface.\n', '    function setup(address _coreAddress, address _pluginsContract) public onlyOwner {\n', '        CutieCoreInterface candidateContract = CutieCoreInterface(_coreAddress);\n', '        require(candidateContract.isCutieCore());\n', '        coreContract = candidateContract;\n', '\n', '        pluginsContract = _pluginsContract;\n', '    }\n', '\n', '    /// @dev Returns true if the claimant owns the token.\n', '    /// @param _claimant - Address claiming to own the token.\n', '    /// @param _cutieId - ID of token whose ownership to verify.\n', '    function _isOwner(address _claimant, uint40 _cutieId) internal view returns (bool) {\n', '        return (coreContract.ownerOf(_cutieId) == _claimant);\n', '    }\n', '\n', '    /// @dev Escrows the NFT, assigning ownership to this contract.\n', '    /// Throws if the escrow fails.\n', '    /// @param _owner - Current owner address of token to escrow.\n', '    /// @param _cutieId - ID of token whose approval to verify.\n', '    function _escrow(address _owner, uint40 _cutieId) internal {\n', '        // it will throw if transfer fails\n', '        coreContract.transferFrom(_owner, this, _cutieId);\n', '    }\n', '\n', '    /// @dev Transfers an NFT owned by this contract to another address.\n', '    /// Returns true if the transfer succeeds.\n', '    /// @param _receiver - Address to transfer NFT to.\n', '    /// @param _cutieId - ID of token to transfer.\n', '    function _transfer(address _receiver, uint40 _cutieId) internal {\n', '        // it will throw if transfer fails\n', '        coreContract.transfer(_receiver, _cutieId);\n', '    }\n', '\n', '    function withdraw() external\n', '    {\n', '        require(\n', '            isOwner(msg.sender) ||\n', '            msg.sender == address(coreContract)\n', '        );\n', '        _withdraw();\n', '    }\n', '\n', '    function _withdraw() internal\n', '    {\n', '        if (address(this).balance > 0)\n', '        {\n', '            address(coreContract).transfer(address(this).balance);\n', '        }\n', '    }\n', '\n', '    function onRemove() public onlyPlugins\n', '    {\n', '        _withdraw();\n', '    }\n', '\n', '    function run(uint40, uint256, address) public payable onlyCore\n', '    {\n', '        revert();\n', '    }\n', '\n', '    function runSigned(uint40, uint256, address) external payable onlyCore\n', '    {\n', '        revert();\n', '    }\n', '}\n', '\n', '\n', '/// @author https://BlockChainArchitect.iocontract Bank is CutiePluginBase\n', 'contract CutiePluginBaseFee is CutiePluginBase\n', '{\n', '    // Cut owner takes on each auction, measured in basis points (1/100 of a percent).\n', '    // Values 0-10,000 map to 0%-100%\n', '    uint16 public ownerFee;\n', '\n', '    /// @dev Constructor creates a reference to the NFT ownership contract\n', '    ///  and verifies the owner cut is in the valid range.\n', '    /// @param _coreAddress - address of a deployed contract implementing\n', '    ///  the Nonfungible Interface.\n', '    /// @param _fee - percent cut the owner takes on each auction, must be\n', '    ///  between 0-10,000.\n', '    function setup(address _coreAddress, address _pluginsContract, uint16 _fee) external onlyOwner {\n', '        require(_fee <= 10000);\n', '        ownerFee = _fee;\n', '\n', '        super.setup(_coreAddress, _pluginsContract);\n', '    }\n', '\n', '    // @dev Set the owner&#39;s fee.\n', '    //  @param fee should be between 0-10,000.\n', '    function setFee(uint16 _fee) external onlyOwner\n', '    {\n', '        require(_fee <= 10000);\n', '\n', '        ownerFee = _fee;\n', '    }\n', '\n', '    /// @dev Computes owner&#39;s cut of a sale.\n', '    /// @param _price - Sale price of NFT.\n', '    function _computeFee(uint128 _price) internal view returns (uint128) {\n', '        // NOTE: We don&#39;t use SafeMath (or similar) in this function because\n', '        //  all of our entry functions carefully cap the maximum values for\n', '        //  currency (at 128-bits), and ownerFee <= 10000 (see the require()\n', '        //  statement in the ClockAuction constructor). The result of this\n', '        //  function is always guaranteed to be <= _price.\n', '        return _price * ownerFee / 10000;\n', '    }\n', '}\n', '\n', '\n', '/// @dev Receives and transfers money from item buyer to seller for Blockchain Cuties\n', '/// @author https://BlockChainArchitect.iocontract Bank is CutiePluginBase\n', 'contract ItemMarket is CutiePluginBaseFee\n', '{\n', '    event Transfer(address from, address to, uint128 value);\n', '\n', '    function run(\n', '        uint40,\n', '        uint256,\n', '        address\n', '    ) \n', '        public\n', '        payable\n', '        onlyPlugins\n', '    {\n', '        revert();\n', '    }\n', '\n', '    function runSigned(uint40, uint256 _parameter, address /*_buyer*/)\n', '        external\n', '        payable\n', '        onlyPlugins\n', '    {\n', '        // first 160 bits - not working on TRON. Cast to address is used instead of it.\n', '        //address seller = address(_parameter % 0x0010000000000000000000000000000000000000000);\n', '        // next 40 bits (shift right by 160 bits)\n', '        uint40 endTime = uint40(_parameter/0x0010000000000000000000000000000000000000000);\n', '        // check if auction is ended\n', '        require(now <= endTime);\n', '        //uint128 fee = _computeFee(uint128(msg.value));\n', '        //uint256 sellerValue = msg.value - fee;\n', '\n', '        uint256 sellerValue = 96*msg.value / 100;\n', '\n', '        // take first 160 bits and use it as seller address\n', '        address(_parameter).transfer(sellerValue);\n', '    }\n', '}']
['pragma solidity ^0.4.23;\n', '\n', 'pragma solidity ^0.4.23;\n', '\n', 'pragma solidity ^0.4.23;\n', '\n', 'pragma solidity ^0.4.23;\n', '\n', '\n', 'pragma solidity ^0.4.23;\n', '\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) public onlyOwner {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract Pausable is Ownable {\n', '  event Pause();\n', '  event Unpause();\n', '\n', '  bool public paused = false;\n', '\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is not paused.\n', '   */\n', '  modifier whenNotPaused() {\n', '    require(!paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev Modifier to make a function callable only when the contract is paused.\n', '   */\n', '  modifier whenPaused() {\n', '    require(paused);\n', '    _;\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to pause, triggers stopped state\n', '   */\n', '  function pause() onlyOwner whenNotPaused public {\n', '    paused = true;\n', '    emit Pause();\n', '  }\n', '\n', '  /**\n', '   * @dev called by the owner to unpause, returns to normal state\n', '   */\n', '  function unpause() onlyOwner whenPaused public {\n', '    paused = false;\n', '    emit Unpause();\n', '  }\n', '}\n', '\n', 'pragma solidity ^0.4.23;\n', '\n', '/// @author https://BlockChainArchitect.iocontract Bank is CutiePluginBase\n', 'contract PluginInterface\n', '{\n', '    /// @dev simply a boolean to indicate this is the contract we expect to be\n', '    function isPluginInterface() public pure returns (bool);\n', '\n', '    function onRemove() public;\n', '\n', '    /// @dev Begins new feature.\n', '    /// @param _cutieId - ID of token to auction, sender must be owner.\n', '    /// @param _parameter - arbitrary parameter\n', '    /// @param _seller - Old owner, if not the message sender\n', '    function run(\n', '        uint40 _cutieId,\n', '        uint256 _parameter,\n', '        address _seller\n', '    )\n', '    public\n', '    payable;\n', '\n', '    /// @dev Begins new feature, approved and signed by COO.\n', '    /// @param _cutieId - ID of token to auction, sender must be owner.\n', '    /// @param _parameter - arbitrary parameter\n', '    function runSigned(\n', '        uint40 _cutieId,\n', '        uint256 _parameter,\n', '        address _owner\n', '    ) external payable;\n', '\n', '    function withdraw() external;\n', '}\n', '\n', 'pragma solidity ^0.4.23;\n', '\n', 'pragma solidity ^0.4.23;\n', '\n', '/// @title BlockchainCuties: Collectible and breedable cuties on the Ethereum blockchain.\n', '/// @author https://BlockChainArchitect.io\n', '/// @dev This is the BlockchainCuties configuration. It can be changed redeploying another version.\n', 'interface ConfigInterface\n', '{\n', '    function isConfig() external pure returns (bool);\n', '\n', '    function getCooldownIndexFromGeneration(uint16 _generation, uint40 _cutieId) external view returns (uint16);\n', '    function getCooldownEndTimeFromIndex(uint16 _cooldownIndex, uint40 _cutieId) external view returns (uint40);\n', '    function getCooldownIndexFromGeneration(uint16 _generation) external view returns (uint16);\n', '    function getCooldownEndTimeFromIndex(uint16 _cooldownIndex) external view returns (uint40);\n', '\n', '    function getCooldownIndexCount() external view returns (uint256);\n', '\n', '    function getBabyGenFromId(uint40 _momId, uint40 _dadId) external view returns (uint16);\n', '    function getBabyGen(uint16 _momGen, uint16 _dadGen) external pure returns (uint16);\n', '\n', '    function getTutorialBabyGen(uint16 _dadGen) external pure returns (uint16);\n', '\n', '    function getBreedingFee(uint40 _momId, uint40 _dadId) external view returns (uint256);\n', '}\n', '\n', '\n', 'contract CutieCoreInterface\n', '{\n', '    function isCutieCore() pure public returns (bool);\n', '\n', '    ConfigInterface public config;\n', '\n', '    function transferFrom(address _from, address _to, uint256 _cutieId) external;\n', '    function transfer(address _to, uint256 _cutieId) external;\n', '\n', '    function ownerOf(uint256 _cutieId)\n', '        external\n', '        view\n', '        returns (address owner);\n', '\n', '    function getCutie(uint40 _id)\n', '        external\n', '        view\n', '        returns (\n', '        uint256 genes,\n', '        uint40 birthTime,\n', '        uint40 cooldownEndTime,\n', '        uint40 momId,\n', '        uint40 dadId,\n', '        uint16 cooldownIndex,\n', '        uint16 generation\n', '    );\n', '\n', '    function getGenes(uint40 _id)\n', '        public\n', '        view\n', '        returns (\n', '        uint256 genes\n', '    );\n', '\n', '\n', '    function getCooldownEndTime(uint40 _id)\n', '        public\n', '        view\n', '        returns (\n', '        uint40 cooldownEndTime\n', '    );\n', '\n', '    function getCooldownIndex(uint40 _id)\n', '        public\n', '        view\n', '        returns (\n', '        uint16 cooldownIndex\n', '    );\n', '\n', '\n', '    function getGeneration(uint40 _id)\n', '        public\n', '        view\n', '        returns (\n', '        uint16 generation\n', '    );\n', '\n', '    function getOptional(uint40 _id)\n', '        public\n', '        view\n', '        returns (\n', '        uint64 optional\n', '    );\n', '\n', '\n', '    function changeGenes(\n', '        uint40 _cutieId,\n', '        uint256 _genes)\n', '        public;\n', '\n', '    function changeCooldownEndTime(\n', '        uint40 _cutieId,\n', '        uint40 _cooldownEndTime)\n', '        public;\n', '\n', '    function changeCooldownIndex(\n', '        uint40 _cutieId,\n', '        uint16 _cooldownIndex)\n', '        public;\n', '\n', '    function changeOptional(\n', '        uint40 _cutieId,\n', '        uint64 _optional)\n', '        public;\n', '\n', '    function changeGeneration(\n', '        uint40 _cutieId,\n', '        uint16 _generation)\n', '        public;\n', '\n', '    function createSaleAuction(\n', '        uint40 _cutieId,\n', '        uint128 _startPrice,\n', '        uint128 _endPrice,\n', '        uint40 _duration\n', '    )\n', '    public;\n', '\n', '    function getApproved(uint256 _tokenId) external returns (address);\n', '    function totalSupply() view external returns (uint256);\n', '    function createPromoCutie(uint256 _genes, address _owner) external;\n', '    function checkOwnerAndApprove(address _claimant, uint40 _cutieId, address _pluginsContract) external view;\n', '    function breedWith(uint40 _momId, uint40 _dadId) public payable returns (uint40);\n', '    function getBreedingFee(uint40 _momId, uint40 _dadId) public view returns (uint256);\n', '    function restoreCutieToAddress(uint40 _cutieId, address _recipient) external;\n', '    function createGen0Auction(uint256 _genes, uint128 startPrice, uint128 endPrice, uint40 duration) external;\n', '    function createGen0AuctionWithTokens(uint256 _genes, uint128 startPrice, uint128 endPrice, uint40 duration, address[] allowedTokens) external;\n', '    function createPromoCutieWithGeneration(uint256 _genes, address _owner, uint16 _generation) external;\n', '    function createPromoCutieBulk(uint256[] _genes, address _owner, uint16 _generation) external;\n', '}\n', '\n', 'pragma solidity ^0.4.23;\n', '\n', '\n', 'pragma solidity ^0.4.23;\n', '\n', 'contract Operators\n', '{\n', '    mapping (address=>bool) ownerAddress;\n', '    mapping (address=>bool) operatorAddress;\n', '\n', '    constructor() public\n', '    {\n', '        ownerAddress[msg.sender] = true;\n', '    }\n', '\n', '    modifier onlyOwner()\n', '    {\n', '        require(ownerAddress[msg.sender]);\n', '        _;\n', '    }\n', '\n', '    function isOwner(address _addr) public view returns (bool) {\n', '        return ownerAddress[_addr];\n', '    }\n', '\n', '    function addOwner(address _newOwner) external onlyOwner {\n', '        require(_newOwner != address(0));\n', '\n', '        ownerAddress[_newOwner] = true;\n', '    }\n', '\n', '    function removeOwner(address _oldOwner) external onlyOwner {\n', '        delete(ownerAddress[_oldOwner]);\n', '    }\n', '\n', '    modifier onlyOperator() {\n', '        require(isOperator(msg.sender));\n', '        _;\n', '    }\n', '\n', '    function isOperator(address _addr) public view returns (bool) {\n', '        return operatorAddress[_addr] || ownerAddress[_addr];\n', '    }\n', '\n', '    function addOperator(address _newOperator) external onlyOwner {\n', '        require(_newOperator != address(0));\n', '\n', '        operatorAddress[_newOperator] = true;\n', '    }\n', '\n', '    function removeOperator(address _oldOperator) external onlyOwner {\n', '        delete(operatorAddress[_oldOperator]);\n', '    }\n', '}\n', '\n', '\n', '\n', '/**\n', ' * @title Pausable\n', ' * @dev Base contract which allows children to implement an emergency stop mechanism.\n', ' */\n', 'contract PausableOperators is Operators {\n', '    event Pause();\n', '    event Unpause();\n', '\n', '    bool public paused = false;\n', '\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable only when the contract is not paused.\n', '     */\n', '    modifier whenNotPaused() {\n', '        require(!paused);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Modifier to make a function callable only when the contract is paused.\n', '     */\n', '    modifier whenPaused() {\n', '        require(paused);\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev called by the owner to pause, triggers stopped state\n', '     */\n', '    function pause() onlyOwner whenNotPaused public {\n', '        paused = true;\n', '        emit Pause();\n', '    }\n', '\n', '    /**\n', '     * @dev called by the owner to unpause, returns to normal state\n', '     */\n', '    function unpause() onlyOwner whenPaused public {\n', '        paused = false;\n', '        emit Unpause();\n', '    }\n', '}\n', '\n', '\n', '/// @author https://BlockChainArchitect.iocontract Bank is CutiePluginBase\n', 'contract CutiePluginBase is PluginInterface, PausableOperators\n', '{\n', '    function isPluginInterface() public pure returns (bool)\n', '    {\n', '        return true;\n', '    }\n', '\n', '    // Reference to contract tracking NFT ownership\n', '    CutieCoreInterface public coreContract;\n', '    address public pluginsContract;\n', '\n', '    // @dev Throws if called by any account other than the owner.\n', '    modifier onlyCore() {\n', '        require(msg.sender == address(coreContract));\n', '        _;\n', '    }\n', '\n', '    modifier onlyPlugins() {\n', '        require(msg.sender == pluginsContract);\n', '        _;\n', '    }\n', '\n', '    /// @dev Constructor creates a reference to the NFT ownership contract\n', '    ///  and verifies the owner cut is in the valid range.\n', '    /// @param _coreAddress - address of a deployed contract implementing\n', '    ///  the Nonfungible Interface.\n', '    function setup(address _coreAddress, address _pluginsContract) public onlyOwner {\n', '        CutieCoreInterface candidateContract = CutieCoreInterface(_coreAddress);\n', '        require(candidateContract.isCutieCore());\n', '        coreContract = candidateContract;\n', '\n', '        pluginsContract = _pluginsContract;\n', '    }\n', '\n', '    /// @dev Returns true if the claimant owns the token.\n', '    /// @param _claimant - Address claiming to own the token.\n', '    /// @param _cutieId - ID of token whose ownership to verify.\n', '    function _isOwner(address _claimant, uint40 _cutieId) internal view returns (bool) {\n', '        return (coreContract.ownerOf(_cutieId) == _claimant);\n', '    }\n', '\n', '    /// @dev Escrows the NFT, assigning ownership to this contract.\n', '    /// Throws if the escrow fails.\n', '    /// @param _owner - Current owner address of token to escrow.\n', '    /// @param _cutieId - ID of token whose approval to verify.\n', '    function _escrow(address _owner, uint40 _cutieId) internal {\n', '        // it will throw if transfer fails\n', '        coreContract.transferFrom(_owner, this, _cutieId);\n', '    }\n', '\n', '    /// @dev Transfers an NFT owned by this contract to another address.\n', '    /// Returns true if the transfer succeeds.\n', '    /// @param _receiver - Address to transfer NFT to.\n', '    /// @param _cutieId - ID of token to transfer.\n', '    function _transfer(address _receiver, uint40 _cutieId) internal {\n', '        // it will throw if transfer fails\n', '        coreContract.transfer(_receiver, _cutieId);\n', '    }\n', '\n', '    function withdraw() external\n', '    {\n', '        require(\n', '            isOwner(msg.sender) ||\n', '            msg.sender == address(coreContract)\n', '        );\n', '        _withdraw();\n', '    }\n', '\n', '    function _withdraw() internal\n', '    {\n', '        if (address(this).balance > 0)\n', '        {\n', '            address(coreContract).transfer(address(this).balance);\n', '        }\n', '    }\n', '\n', '    function onRemove() public onlyPlugins\n', '    {\n', '        _withdraw();\n', '    }\n', '\n', '    function run(uint40, uint256, address) public payable onlyCore\n', '    {\n', '        revert();\n', '    }\n', '\n', '    function runSigned(uint40, uint256, address) external payable onlyCore\n', '    {\n', '        revert();\n', '    }\n', '}\n', '\n', '\n', '/// @author https://BlockChainArchitect.iocontract Bank is CutiePluginBase\n', 'contract CutiePluginBaseFee is CutiePluginBase\n', '{\n', '    // Cut owner takes on each auction, measured in basis points (1/100 of a percent).\n', '    // Values 0-10,000 map to 0%-100%\n', '    uint16 public ownerFee;\n', '\n', '    /// @dev Constructor creates a reference to the NFT ownership contract\n', '    ///  and verifies the owner cut is in the valid range.\n', '    /// @param _coreAddress - address of a deployed contract implementing\n', '    ///  the Nonfungible Interface.\n', '    /// @param _fee - percent cut the owner takes on each auction, must be\n', '    ///  between 0-10,000.\n', '    function setup(address _coreAddress, address _pluginsContract, uint16 _fee) external onlyOwner {\n', '        require(_fee <= 10000);\n', '        ownerFee = _fee;\n', '\n', '        super.setup(_coreAddress, _pluginsContract);\n', '    }\n', '\n', "    // @dev Set the owner's fee.\n", '    //  @param fee should be between 0-10,000.\n', '    function setFee(uint16 _fee) external onlyOwner\n', '    {\n', '        require(_fee <= 10000);\n', '\n', '        ownerFee = _fee;\n', '    }\n', '\n', "    /// @dev Computes owner's cut of a sale.\n", '    /// @param _price - Sale price of NFT.\n', '    function _computeFee(uint128 _price) internal view returns (uint128) {\n', "        // NOTE: We don't use SafeMath (or similar) in this function because\n", '        //  all of our entry functions carefully cap the maximum values for\n', '        //  currency (at 128-bits), and ownerFee <= 10000 (see the require()\n', '        //  statement in the ClockAuction constructor). The result of this\n', '        //  function is always guaranteed to be <= _price.\n', '        return _price * ownerFee / 10000;\n', '    }\n', '}\n', '\n', '\n', '/// @dev Receives and transfers money from item buyer to seller for Blockchain Cuties\n', '/// @author https://BlockChainArchitect.iocontract Bank is CutiePluginBase\n', 'contract ItemMarket is CutiePluginBaseFee\n', '{\n', '    event Transfer(address from, address to, uint128 value);\n', '\n', '    function run(\n', '        uint40,\n', '        uint256,\n', '        address\n', '    ) \n', '        public\n', '        payable\n', '        onlyPlugins\n', '    {\n', '        revert();\n', '    }\n', '\n', '    function runSigned(uint40, uint256 _parameter, address /*_buyer*/)\n', '        external\n', '        payable\n', '        onlyPlugins\n', '    {\n', '        // first 160 bits - not working on TRON. Cast to address is used instead of it.\n', '        //address seller = address(_parameter % 0x0010000000000000000000000000000000000000000);\n', '        // next 40 bits (shift right by 160 bits)\n', '        uint40 endTime = uint40(_parameter/0x0010000000000000000000000000000000000000000);\n', '        // check if auction is ended\n', '        require(now <= endTime);\n', '        //uint128 fee = _computeFee(uint128(msg.value));\n', '        //uint256 sellerValue = msg.value - fee;\n', '\n', '        uint256 sellerValue = 96*msg.value / 100;\n', '\n', '        // take first 160 bits and use it as seller address\n', '        address(_parameter).transfer(sellerValue);\n', '    }\n', '}']