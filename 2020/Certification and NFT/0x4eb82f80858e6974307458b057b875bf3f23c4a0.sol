['// File: contracts/external/proxy/Proxy.sol\n', '\n', 'pragma solidity 0.5.7;\n', '\n', '\n', '/**\n', ' * @title Proxy\n', ' * @dev Gives the possibility to delegate any call to a foreign implementation.\n', ' */\n', 'contract Proxy {\n', '    /**\n', '    * @dev Fallback function allowing to perform a delegatecall to the given implementation.\n', '    * This function will return whatever the implementation call returns\n', '    */\n', '    function () external payable {\n', '        address _impl = implementation();\n', '        require(_impl != address(0));\n', '\n', '        assembly {\n', '            let ptr := mload(0x40)\n', '            calldatacopy(ptr, 0, calldatasize)\n', '            let result := delegatecall(gas, _impl, ptr, calldatasize, 0, 0)\n', '            let size := returndatasize\n', '            returndatacopy(ptr, 0, size)\n', '\n', '            switch result\n', '            case 0 { revert(ptr, size) }\n', '            default { return(ptr, size) }\n', '            }\n', '    }\n', '\n', '    /**\n', '    * @dev Tells the address of the implementation where every call will be delegated.\n', '    * @return address of the implementation to which it will be delegated\n', '    */\n', '    function implementation() public view returns (address);\n', '}\n', '\n', '// File: contracts/external/proxy/UpgradeabilityProxy.sol\n', '\n', 'pragma solidity 0.5.7;\n', '\n', '\n', '\n', '/**\n', ' * @title UpgradeabilityProxy\n', ' * @dev This contract represents a proxy where the implementation address to which it will delegate can be upgraded\n', ' */\n', 'contract UpgradeabilityProxy is Proxy {\n', '    /**\n', '    * @dev This event will be emitted every time the implementation gets upgraded\n', '    * @param implementation representing the address of the upgraded implementation\n', '    */\n', '    event Upgraded(address indexed implementation);\n', '\n', '    // Storage position of the address of the current implementation\n', '    bytes32 private constant IMPLEMENTATION_POSITION = keccak256("org.govblocks.proxy.implementation");\n', '\n', '    /**\n', '    * @dev Constructor function\n', '    */\n', '    constructor() public {}\n', '\n', '    /**\n', '    * @dev Tells the address of the current implementation\n', '    * @return address of the current implementation\n', '    */\n', '    function implementation() public view returns (address impl) {\n', '        bytes32 position = IMPLEMENTATION_POSITION;\n', '        assembly {\n', '            impl := sload(position)\n', '        }\n', '    }\n', '\n', '    /**\n', '    * @dev Sets the address of the current implementation\n', '    * @param _newImplementation address representing the new implementation to be set\n', '    */\n', '    function _setImplementation(address _newImplementation) internal {\n', '        bytes32 position = IMPLEMENTATION_POSITION;\n', '        assembly {\n', '        sstore(position, _newImplementation)\n', '        }\n', '    }\n', '\n', '    /**\n', '    * @dev Upgrades the implementation address\n', '    * @param _newImplementation representing the address of the new implementation to be set\n', '    */\n', '    function _upgradeTo(address _newImplementation) internal {\n', '        address currentImplementation = implementation();\n', '        require(currentImplementation != _newImplementation);\n', '        _setImplementation(_newImplementation);\n', '        emit Upgraded(_newImplementation);\n', '    }\n', '}\n', '\n', '// File: contracts/external/proxy/OwnedUpgradeabilityProxy.sol\n', '\n', 'pragma solidity 0.5.7;\n', '\n', '\n', '\n', '/**\n', ' * @title OwnedUpgradeabilityProxy\n', ' * @dev This contract combines an upgradeability proxy with basic authorization control functionalities\n', ' */\n', 'contract OwnedUpgradeabilityProxy is UpgradeabilityProxy {\n', '    /**\n', '    * @dev Event to show ownership has been transferred\n', '    * @param previousOwner representing the address of the previous owner\n', '    * @param newOwner representing the address of the new owner\n', '    */\n', '    event ProxyOwnershipTransferred(address previousOwner, address newOwner);\n', '\n', '    // Storage position of the owner of the contract\n', '    bytes32 private constant PROXY_OWNER_POSITION = keccak256("org.govblocks.proxy.owner");\n', '\n', '    /**\n', '    * @dev the constructor sets the original owner of the contract to the sender account.\n', '    */\n', '    constructor(address _implementation) public {\n', '        _setUpgradeabilityOwner(msg.sender);\n', '        _upgradeTo(_implementation);\n', '    }\n', '\n', '    /**\n', '    * @dev Throws if called by any account other than the owner.\n', '    */\n', '    modifier onlyProxyOwner() {\n', '        require(msg.sender == proxyOwner());\n', '        _;\n', '    }\n', '\n', '    /**\n', '    * @dev Tells the address of the owner\n', '    * @return the address of the owner\n', '    */\n', '    function proxyOwner() public view returns (address owner) {\n', '        bytes32 position = PROXY_OWNER_POSITION;\n', '        assembly {\n', '            owner := sload(position)\n', '        }\n', '    }\n', '\n', '    /**\n', '    * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '    * @param _newOwner The address to transfer ownership to.\n', '    */\n', '    function transferProxyOwnership(address _newOwner) public onlyProxyOwner {\n', '        require(_newOwner != address(0));\n', '        _setUpgradeabilityOwner(_newOwner);\n', '        emit ProxyOwnershipTransferred(proxyOwner(), _newOwner);\n', '    }\n', '\n', '    /**\n', '    * @dev Allows the proxy owner to upgrade the current version of the proxy.\n', '    * @param _implementation representing the address of the new implementation to be set.\n', '    */\n', '    function upgradeTo(address _implementation) public onlyProxyOwner {\n', '        _upgradeTo(_implementation);\n', '    }\n', '\n', '    /**\n', '     * @dev Sets the address of the owner\n', '    */\n', '    function _setUpgradeabilityOwner(address _newProxyOwner) internal {\n', '        bytes32 position = PROXY_OWNER_POSITION;\n', '        assembly {\n', '            sstore(position, _newProxyOwner)\n', '        }\n', '    }\n', '}\n', '\n', '// File: contracts/external/govblocks-protocol/Governed.sol\n', '\n', '/* Copyright (C) 2017 GovBlocks.io\n', '  This program is free software: you can redistribute it and/or modify\n', '    it under the terms of the GNU General Public License as published by\n', '    the Free Software Foundation, either version 3 of the License, or\n', '    (at your option) any later version.\n', '  This program is distributed in the hope that it will be useful,\n', '    but WITHOUT ANY WARRANTY; without even the implied warranty of\n', '    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n', '    GNU General Public License for more details.\n', '  You should have received a copy of the GNU General Public License\n', '    along with this program.  If not, see http://www.gnu.org/licenses/ */\n', '\n', 'pragma solidity 0.5.7;\n', '\n', '\n', 'contract IMaster {\n', '    mapping(address => bool) public whitelistedSponsor;\n', '    function dAppToken() public view returns(address);\n', '    function isInternal(address _address) public view returns(bool);\n', '    function getLatestAddress(bytes2 _module) public view returns(address);\n', '    function isAuthorizedToGovern(address _toCheck) public view returns(bool);\n', '}\n', '\n', '\n', 'contract Governed {\n', '\n', '    address public masterAddress; // Name of the dApp, needs to be set by contracts inheriting this contract\n', '\n', '    /// @dev modifier that allows only the authorized addresses to execute the function\n', '    modifier onlyAuthorizedToGovern() {\n', '        IMaster ms = IMaster(masterAddress);\n', '        require(ms.getLatestAddress("GV") == msg.sender, "Not authorized");\n', '        _;\n', '    }\n', '\n', '    /// @dev checks if an address is authorized to govern\n', '    function isAuthorizedToGovern(address _toCheck) public view returns(bool) {\n', '        IMaster ms = IMaster(masterAddress);\n', '        return (ms.getLatestAddress("GV") == _toCheck);\n', '    } \n', '\n', '}\n', '\n', '// File: contracts/external/govblocks-protocol/interfaces/IMemberRoles.sol\n', '\n', '/* Copyright (C) 2017 GovBlocks.io\n', '  This program is free software: you can redistribute it and/or modify\n', '    it under the terms of the GNU General Public License as published by\n', '    the Free Software Foundation, either version 3 of the License, or\n', '    (at your option) any later version.\n', '  This program is distributed in the hope that it will be useful,\n', '    but WITHOUT ANY WARRANTY; without even the implied warranty of\n', '    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n', '    GNU General Public License for more details.\n', '  You should have received a copy of the GNU General Public License\n', '    along with this program.  If not, see http://www.gnu.org/licenses/ */\n', '\n', 'pragma solidity 0.5.7;\n', '\n', '\n', 'contract IMemberRoles {\n', '\n', '    event MemberRole(uint256 indexed roleId, bytes32 roleName, string roleDescription);\n', '    \n', '    enum Role {UnAssigned, AdvisoryBoard, TokenHolder, DisputeResolution}\n', '\n', '    function setInititorAddress(address _initiator) external;\n', '\n', '    /// @dev Adds new member role\n', '    /// @param _roleName New role name\n', '    /// @param _roleDescription New description hash\n', '    /// @param _authorized Authorized member against every role id\n', '    function addRole(bytes32 _roleName, string memory _roleDescription, address _authorized) public;\n', '\n', '    /// @dev Assign or Delete a member from specific role.\n', '    /// @param _memberAddress Address of Member\n', '    /// @param _roleId RoleId to update\n', '    /// @param _active active is set to be True if we want to assign this role to member, False otherwise!\n', '    function updateRole(address _memberAddress, uint _roleId, bool _active) public;\n', '\n', '    /// @dev Change Member Address who holds the authority to Add/Delete any member from specific role.\n', '    /// @param _roleId roleId to update its Authorized Address\n', '    /// @param _authorized New authorized address against role id\n', '    function changeAuthorized(uint _roleId, address _authorized) public;\n', '\n', '    /// @dev Return number of member roles\n', '    function totalRoles() public view returns(uint256);\n', '\n', '    /// @dev Gets the member addresses assigned by a specific role\n', '    /// @param _memberRoleId Member role id\n', '    /// @return roleId Role id\n', '    /// @return allMemberAddress Member addresses of specified role id\n', '    function members(uint _memberRoleId) public view returns(uint, address[] memory allMemberAddress);\n', '\n', "    /// @dev Gets all members' length\n", '    /// @param _memberRoleId Member role id\n', '    /// @return memberRoleData[_memberRoleId].memberAddress.length Member length\n', '    function numberOfMembers(uint _memberRoleId) public view returns(uint);\n', '    \n', '    /// @dev Return member address who holds the right to add/remove any member from specific role.\n', '    function authorized(uint _memberRoleId) public view returns(address);\n', '\n', '    /// @dev Get All role ids array that has been assigned to a member so far.\n', '    function roles(address _memberAddress) public view returns(uint[] memory assignedRoles);\n', '\n', '    /// @dev Returns true if the given role id is assigned to a member.\n', '    /// @param _memberAddress Address of member\n', "    /// @param _roleId Checks member's authenticity with the roleId.\n", '    /// i.e. Returns true if this roleId is assigned to member\n', '    function checkRole(address _memberAddress, uint _roleId) public view returns(bool);   \n', '}\n', '\n', '// File: contracts/interfaces/IMarketRegistry.sol\n', '\n', 'pragma solidity 0.5.7;\n', '\n', 'contract IMarketRegistry {\n', '\n', '    enum MarketType {\n', '      HourlyMarket,\n', '      DailyMarket,\n', '      WeeklyMarket\n', '    }\n', '    address public owner;\n', '    address public tokenController;\n', '    address public marketUtility;\n', '    bool public marketCreationPaused;\n', '\n', '    mapping(address => bool) public isMarket;\n', '    function() external payable{}\n', '\n', '    function marketDisputeStatus(address _marketAddress) public view returns(uint _status);\n', '\n', '    function burnDisputedProposalTokens(uint _proposaId) external;\n', '\n', '    function isWhitelistedSponsor(address _address) public view returns(bool);\n', '\n', '    function transferAssets(address _asset, address _to, uint _amount) external;\n', '\n', '    /**\n', '    * @dev Initialize the PlotX.\n', '    * @param _marketConfig The address of market config.\n', '    * @param _plotToken The address of PLOT token.\n', '    */\n', '    function initiate(address _defaultAddress, address _marketConfig, address _plotToken, address payable[] memory _configParams) public;\n', '\n', '    /**\n', '    * @dev Create proposal if user wants to raise the dispute.\n', '    * @param proposalTitle The title of proposal created by user.\n', '    * @param description The description of dispute.\n', '    * @param solutionHash The ipfs solution hash.\n', '    * @param actionHash The action hash for solution.\n', '    * @param stakeForDispute The token staked to raise the diospute.\n', '    * @param user The address who raises the dispute.\n', '    */\n', '    function createGovernanceProposal(string memory proposalTitle, string memory description, string memory solutionHash, bytes memory actionHash, uint256 stakeForDispute, address user, uint256 ethSentToPool, uint256 tokenSentToPool, uint256 proposedValue) public {\n', '    }\n', '\n', '    /**\n', '    * @dev Emits the PlacePrediction event and sets user data.\n', '    * @param _user The address who placed prediction.\n', '    * @param _value The amount of ether user staked.\n', '    * @param _predictionPoints The positions user will get.\n', '    * @param _predictionAsset The prediction assets user will get.\n', '    * @param _prediction The option range on which user placed prediction.\n', '    * @param _leverage The leverage selected by user at the time of place prediction.\n', '    */\n', '    function setUserGlobalPredictionData(address _user,uint _value, uint _predictionPoints, address _predictionAsset, uint _prediction,uint _leverage) public{\n', '    }\n', '\n', '    /**\n', '    * @dev Emits the claimed event.\n', '    * @param _user The address who claim their reward.\n', '    * @param _reward The reward which is claimed by user.\n', '    * @param incentives The incentives of user.\n', '    * @param incentiveToken The incentive tokens of user.\n', '    */\n', '    function callClaimedEvent(address _user , uint[] memory _reward, address[] memory predictionAssets, uint incentives, address incentiveToken) public {\n', '    }\n', '\n', '        /**\n', '    * @dev Emits the MarketResult event.\n', '    * @param _totalReward The amount of reward to be distribute.\n', '    * @param _winningOption The winning option of the market.\n', '    * @param _closeValue The closing value of the market currency.\n', '    */\n', '    function callMarketResultEvent(uint[] memory _totalReward, uint _winningOption, uint _closeValue, uint roundId) public {\n', '    }\n', '}\n', '\n', '// File: contracts/interfaces/IbLOTToken.sol\n', '\n', 'pragma solidity 0.5.7;\n', '\n', 'contract IbLOTToken {\n', '    function initiatebLOT(address _defaultMinter) external;\n', '    function convertToPLOT(address _of, address _to, uint256 amount) public;\n', '}\n', '\n', '// File: contracts/interfaces/ITokenController.sol\n', '\n', 'pragma solidity 0.5.7;\n', '\n', 'contract ITokenController {\n', '\taddress public token;\n', '    address public bLOTToken;\n', '\n', '    /**\n', '    * @dev Swap BLOT token.\n', '    * account.\n', '    * @param amount The amount that will be swapped.\n', '    */\n', '    function swapBLOT(address _of, address _to, uint256 amount) public;\n', '\n', '    function totalBalanceOf(address _of)\n', '        public\n', '        view\n', '        returns (uint256 amount);\n', '\n', '    function transferFrom(address _token, address _of, address _to, uint256 amount) public;\n', '\n', '    /**\n', '     * @dev Returns tokens locked for a specified address for a\n', '     *      specified reason at a specific time\n', '     * @param _of The address whose tokens are locked\n', '     * @param _reason The reason to query the lock tokens for\n', '     * @param _time The timestamp to query the lock tokens for\n', '     */\n', '    function tokensLockedAtTime(address _of, bytes32 _reason, uint256 _time)\n', '        public\n', '        view\n', '        returns (uint256 amount);\n', '\n', '    /**\n', '    * @dev burns an amount of the tokens of the message sender\n', '    * account.\n', '    * @param amount The amount that will be burnt.\n', '    */\n', '    function burnCommissionTokens(uint256 amount) external returns(bool);\n', ' \n', '    function initiateVesting(address _vesting) external;\n', '\n', '    function lockForGovernanceVote(address _of, uint _days) public;\n', '\n', '    function totalSupply() public view returns (uint256);\n', '\n', '    function mint(address _member, uint _amount) public;\n', '\n', '}\n', '\n', '// File: contracts/interfaces/Iupgradable.sol\n', '\n', 'pragma solidity 0.5.7;\n', '\n', 'contract Iupgradable {\n', '\n', '    /**\n', '     * @dev change master address\n', '     */\n', '    function setMasterAddress() public;\n', '}\n', '\n', '// File: contracts/Master.sol\n', '\n', '/* Copyright (C) 2020 PlotX.io\n', '\n', '  This program is free software: you can redistribute it and/or modify\n', '    it under the terms of the GNU General Public License as published by\n', '    the Free Software Foundation, either version 3 of the License, or\n', '    (at your option) any later version.\n', '\n', '  This program is distributed in the hope that it will be useful,\n', '    but WITHOUT ANY WARRANTY; without even the implied warranty of\n', '    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n', '    GNU General Public License for more details.\n', '\n', '  You should have received a copy of the GNU General Public License\n', '    along with this program.  If not, see http://www.gnu.org/licenses/ */\n', '\n', 'pragma solidity 0.5.7;\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', '\n', 'contract Master is Governed {\n', '    bytes2[] public allContractNames;\n', '    address public dAppToken;\n', '    address public dAppLocker;\n', '    bool public masterInitialised;\n', '\n', '    mapping(address => bool) public contractsActive;\n', '    mapping(address => bool) public whitelistedSponsor;\n', '    mapping(bytes2 => address payable) public contractAddress;\n', '\n', '    /**\n', '     * @dev modifier that allows only the authorized addresses to execute the function\n', '     */\n', '    modifier onlyAuthorizedToGovern() {\n', '        require(getLatestAddress("GV") == msg.sender, "Not authorized");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Initialize the Master.\n', '     * @param _implementations The address of market implementation.\n', '     * @param _token The address of PLOT token.\n', '     * @param _marketUtiliy The addresses of market utility.\n', '     */\n', '    function initiateMaster(\n', '        address[] calldata _implementations,\n', '        address _token,\n', '        address _defaultAddress,\n', '        address _marketUtiliy,\n', '        address payable[] calldata _configParams,\n', '        address _vesting\n', '    ) external {\n', '        OwnedUpgradeabilityProxy proxy = OwnedUpgradeabilityProxy(\n', '            address(uint160(address(this)))\n', '        );\n', '        require(!masterInitialised);\n', '        require(msg.sender == proxy.proxyOwner(), "Sender is not proxy owner.");\n', '        masterInitialised = true;\n', '\n', '        //Initial contract names\n', '        allContractNames.push("MR");\n', '        allContractNames.push("PC");\n', '        allContractNames.push("GV");\n', '        allContractNames.push("PL");\n', '        allContractNames.push("TC");\n', '        allContractNames.push("BL");\n', '\n', '        require(\n', '            allContractNames.length == _implementations.length,\n', '            "Implementation length not match"\n', '        );\n', '        contractsActive[address(this)] = true;\n', '        dAppToken = _token;\n', '        for (uint256 i = 0; i < allContractNames.length; i++) {\n', '            _generateProxy(allContractNames[i], _implementations[i]);\n', '        }\n', '        dAppLocker = contractAddress["TC"];\n', '\n', '        _setMasterAddress();\n', '\n', '        IMarketRegistry(contractAddress["PL"]).initiate(\n', '            _defaultAddress,\n', '            _marketUtiliy,\n', '            _token,\n', '            _configParams\n', '        );\n', '        IbLOTToken(contractAddress["BL"]).initiatebLOT(_defaultAddress);\n', '        ITokenController(contractAddress["TC"]).initiateVesting(_vesting);\n', '        IMemberRoles(contractAddress["MR"]).setInititorAddress(_defaultAddress);\n', '    }\n', '\n', '    /**\n', '     * @dev adds a new contract type to master\n', '     */\n', '    function addNewContract(bytes2 _contractName, address _contractAddress)\n', '        external\n', '        onlyAuthorizedToGovern\n', '    {\n', '        require(_contractName != "MS", "Name cannot be master");\n', '        require(_contractAddress != address(0), "Zero address");\n', '        require(\n', '            contractAddress[_contractName] == address(0),\n', '            "Contract code already available"\n', '        );\n', '        allContractNames.push(_contractName);\n', '        _generateProxy(_contractName, _contractAddress);\n', '        Iupgradable up = Iupgradable(contractAddress[_contractName]);\n', '        up.setMasterAddress();\n', '    }\n', '\n', '    /**\n', '     * @dev upgrades a multiple contract implementations\n', '     */\n', '    function upgradeMultipleImplementations(\n', '        bytes2[] calldata _contractNames,\n', '        address[] calldata _contractAddresses\n', '    ) external onlyAuthorizedToGovern {\n', '        require(\n', '            _contractNames.length == _contractAddresses.length,\n', '            "Array length should be equal."\n', '        );\n', '        for (uint256 i = 0; i < _contractNames.length; i++) {\n', '            require(\n', '                _contractAddresses[i] != address(0),\n', '                "null address is not allowed."\n', '            );\n', '            _replaceImplementation(_contractNames[i], _contractAddresses[i]);\n', '        }\n', '    }\n', '\n', '    function whitelistSponsor(address _address) external onlyAuthorizedToGovern {\n', '        whitelistedSponsor[_address] = true;\n', '    }\n', '\n', '    \n', '    /**\n', '     * @dev To check if we use the particular contract.\n', '     * @param _address The contract address to check if it is active or not.\n', '     */\n', '    function isInternal(address _address) public view returns (bool) {\n', '        return contractsActive[_address];\n', '    }\n', '\n', '    /**\n', '     * @dev Gets latest contract address\n', '     * @param _contractName Contract name to fetch\n', '     */\n', '    function getLatestAddress(bytes2 _contractName)\n', '        public\n', '        view\n', '        returns (address)\n', '    {\n', '        return contractAddress[_contractName];\n', '    }\n', '\n', '    /**\n', '     * @dev checks if an address is authorized to govern\n', '     */\n', '    function isAuthorizedToGovern(address _toCheck) public view returns (bool) {\n', '        return (getLatestAddress("GV") == _toCheck);\n', '    }\n', '\n', '    /**\n', '     * @dev Changes Master contract address\n', '     */\n', '    function _setMasterAddress() internal {\n', '        for (uint256 i = 0; i < allContractNames.length; i++) {\n', '            Iupgradable up = Iupgradable(contractAddress[allContractNames[i]]);\n', '            up.setMasterAddress();\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Replaces the implementations of the contract.\n', '     * @param _contractsName The name of the contract.\n', '     * @param _contractAddress The address of the contract to replace the implementations for.\n', '     */\n', '    function _replaceImplementation(\n', '        bytes2 _contractsName,\n', '        address _contractAddress\n', '    ) internal {\n', '        OwnedUpgradeabilityProxy tempInstance = OwnedUpgradeabilityProxy(\n', '            contractAddress[_contractsName]\n', '        );\n', '        tempInstance.upgradeTo(_contractAddress);\n', '    }\n', '\n', '    /**\n', '     * @dev to generator proxy\n', '     * @param _contractAddress of the proxy\n', '     */\n', '    function _generateProxy(bytes2 _contractName, address _contractAddress)\n', '        internal\n', '    {\n', '        OwnedUpgradeabilityProxy tempInstance = new OwnedUpgradeabilityProxy(\n', '            _contractAddress\n', '        );\n', '        contractAddress[_contractName] = address(tempInstance);\n', '        contractsActive[address(tempInstance)] = true;\n', '    }\n', '}']