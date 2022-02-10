['pragma solidity ^0.4.19;\n', '\n', '// copyright contact@etheremon.com\n', '\n', 'contract BasicAccessControl {\n', '    address public owner;\n', '    // address[] public moderators;\n', '    uint16 public totalModerators = 0;\n', '    mapping (address => bool) public moderators;\n', '    bool public isMaintaining = false;\n', '\n', '    function BasicAccessControl() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    modifier onlyModerators() {\n', '        require(msg.sender == owner || moderators[msg.sender] == true);\n', '        _;\n', '    }\n', '\n', '    modifier isActive {\n', '        require(!isMaintaining);\n', '        _;\n', '    }\n', '\n', '    function ChangeOwner(address _newOwner) onlyOwner public {\n', '        if (_newOwner != address(0)) {\n', '            owner = _newOwner;\n', '        }\n', '    }\n', '\n', '\n', '    function AddModerator(address _newModerator) onlyOwner public {\n', '        if (moderators[_newModerator] == false) {\n', '            moderators[_newModerator] = true;\n', '            totalModerators += 1;\n', '        }\n', '    }\n', '    \n', '    function RemoveModerator(address _oldModerator) onlyOwner public {\n', '        if (moderators[_oldModerator] == true) {\n', '            moderators[_oldModerator] = false;\n', '            totalModerators -= 1;\n', '        }\n', '    }\n', '\n', '    function UpdateMaintaining(bool _isMaintaining) onlyOwner public {\n', '        isMaintaining = _isMaintaining;\n', '    }\n', '}\n', '\n', '\n', 'contract EtheremonEnergy is BasicAccessControl {\n', '    \n', '    struct Energy {\n', '        uint freeAmount;\n', '        uint paidAmount;\n', '        uint lastClaim;\n', '    }\n', '    \n', '    struct EnergyPackage {\n', '        uint ethPrice;\n', '        uint emontPrice;\n', '        uint energy;\n', '    }\n', '    \n', '    mapping(address => Energy) energyData;\n', '    mapping(uint => EnergyPackage) paidPackages;\n', '    uint public claimMaxAmount = 10;\n', '    uint public claimTime = 30 * 60; // in second\n', '    uint public claimAmount = 1;\n', '    \n', '    // address\n', '    address public paymentContract;\n', '    \n', '    // event\n', '    event EventEnergyUpdate(address indexed player, uint freeAmount, uint paidAmount, uint lastClaim);\n', '    \n', '    modifier requirePaymentContract {\n', '        require(paymentContract != address(0));\n', '        _;\n', '    }\n', '    \n', '    function EtheremonEnergy(address _paymentContract) public {\n', '        paymentContract = _paymentContract;\n', '    }\n', '    \n', '    // moderator\n', '    \n', '    function withdrawEther(address _sendTo, uint _amount) onlyModerators public {\n', '        if (_amount > address(this).balance) {\n', '            revert();\n', '        }\n', '        _sendTo.transfer(_amount);\n', '    }\n', '    \n', '    function setPaidPackage(uint _packId, uint _ethPrice, uint _emontPrice, uint _energy) onlyModerators external {\n', '        EnergyPackage storage pack = paidPackages[_packId];\n', '        pack.ethPrice = _ethPrice;\n', '        pack.emontPrice = _emontPrice;\n', '        pack.energy = _energy;\n', '    }\n', '    \n', '    function setConfig(address _paymentContract, uint _claimMaxAmount, uint _claimTime, uint _claimAmount) onlyModerators external {\n', '        paymentContract = _paymentContract;\n', '        claimMaxAmount = _claimMaxAmount;\n', '        claimTime = _claimTime;\n', '        claimAmount = _claimAmount;\n', '    }\n', '    \n', '    function topupEnergyByToken(address _player, uint _packId, uint _token) requirePaymentContract external {\n', '        if (msg.sender != paymentContract) revert();\n', '        EnergyPackage storage pack = paidPackages[_packId];\n', '        if (pack.energy == 0 || pack.emontPrice != _token)\n', '            revert();\n', '\n', '        Energy storage energy = energyData[_player];\n', '        energy.paidAmount += pack.energy;\n', '        \n', '        EventEnergyUpdate(_player, energy.freeAmount, energy.paidAmount, energy.lastClaim);\n', '    }\n', '    \n', '    // public update\n', '    \n', '    function safeDeduct(uint _a, uint _b) pure public returns(uint) {\n', '        if (_a < _b) return 0;\n', '        return (_a - _b);\n', '    }\n', '    \n', '    function topupEnergy(uint _packId) isActive payable external {\n', '        EnergyPackage storage pack = paidPackages[_packId];\n', '        if (pack.energy == 0 || pack.ethPrice != msg.value)\n', '            revert();\n', '\n', '        Energy storage energy = energyData[msg.sender];\n', '        energy.paidAmount += pack.energy;\n', '        \n', '        EventEnergyUpdate(msg.sender, energy.freeAmount, energy.paidAmount, energy.lastClaim);\n', '    }\n', '    \n', '    function claimEnergy() isActive external {\n', '        Energy storage energy = energyData[msg.sender];\n', '        uint period = safeDeduct(block.timestamp, energy.lastClaim);\n', '        uint energyAmount = (period / claimTime) * claimAmount;\n', '        \n', '        if (energyAmount == 0) revert();\n', '        if (energyAmount > claimMaxAmount) energyAmount = claimMaxAmount;\n', '        \n', '        energy.freeAmount += energyAmount;\n', '        energy.lastClaim = block.timestamp;\n', '        \n', '        EventEnergyUpdate(msg.sender, energy.freeAmount, energy.paidAmount, energy.lastClaim);\n', '    }\n', '    \n', '    // public get\n', '    function getPlayerEnergy(address _player) constant external returns(uint freeAmount, uint paidAmount, uint lastClaim) {\n', '        Energy storage energy = energyData[_player];\n', '        return (energy.freeAmount, energy.paidAmount, energy.lastClaim);\n', '    }\n', '    \n', '    function getClaimableAmount(address _trainer) constant external returns(uint) {\n', '        Energy storage energy = energyData[_trainer];\n', '        uint period = safeDeduct(block.timestamp, energy.lastClaim);\n', '        uint energyAmount = (period / claimTime) * claimAmount;\n', '        if (energyAmount > claimMaxAmount) energyAmount = claimMaxAmount;\n', '        return energyAmount;\n', '    }\n', '}']
['pragma solidity ^0.4.19;\n', '\n', '// copyright contact@etheremon.com\n', '\n', 'contract BasicAccessControl {\n', '    address public owner;\n', '    // address[] public moderators;\n', '    uint16 public totalModerators = 0;\n', '    mapping (address => bool) public moderators;\n', '    bool public isMaintaining = false;\n', '\n', '    function BasicAccessControl() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    modifier onlyModerators() {\n', '        require(msg.sender == owner || moderators[msg.sender] == true);\n', '        _;\n', '    }\n', '\n', '    modifier isActive {\n', '        require(!isMaintaining);\n', '        _;\n', '    }\n', '\n', '    function ChangeOwner(address _newOwner) onlyOwner public {\n', '        if (_newOwner != address(0)) {\n', '            owner = _newOwner;\n', '        }\n', '    }\n', '\n', '\n', '    function AddModerator(address _newModerator) onlyOwner public {\n', '        if (moderators[_newModerator] == false) {\n', '            moderators[_newModerator] = true;\n', '            totalModerators += 1;\n', '        }\n', '    }\n', '    \n', '    function RemoveModerator(address _oldModerator) onlyOwner public {\n', '        if (moderators[_oldModerator] == true) {\n', '            moderators[_oldModerator] = false;\n', '            totalModerators -= 1;\n', '        }\n', '    }\n', '\n', '    function UpdateMaintaining(bool _isMaintaining) onlyOwner public {\n', '        isMaintaining = _isMaintaining;\n', '    }\n', '}\n', '\n', '\n', 'contract EtheremonEnergy is BasicAccessControl {\n', '    \n', '    struct Energy {\n', '        uint freeAmount;\n', '        uint paidAmount;\n', '        uint lastClaim;\n', '    }\n', '    \n', '    struct EnergyPackage {\n', '        uint ethPrice;\n', '        uint emontPrice;\n', '        uint energy;\n', '    }\n', '    \n', '    mapping(address => Energy) energyData;\n', '    mapping(uint => EnergyPackage) paidPackages;\n', '    uint public claimMaxAmount = 10;\n', '    uint public claimTime = 30 * 60; // in second\n', '    uint public claimAmount = 1;\n', '    \n', '    // address\n', '    address public paymentContract;\n', '    \n', '    // event\n', '    event EventEnergyUpdate(address indexed player, uint freeAmount, uint paidAmount, uint lastClaim);\n', '    \n', '    modifier requirePaymentContract {\n', '        require(paymentContract != address(0));\n', '        _;\n', '    }\n', '    \n', '    function EtheremonEnergy(address _paymentContract) public {\n', '        paymentContract = _paymentContract;\n', '    }\n', '    \n', '    // moderator\n', '    \n', '    function withdrawEther(address _sendTo, uint _amount) onlyModerators public {\n', '        if (_amount > address(this).balance) {\n', '            revert();\n', '        }\n', '        _sendTo.transfer(_amount);\n', '    }\n', '    \n', '    function setPaidPackage(uint _packId, uint _ethPrice, uint _emontPrice, uint _energy) onlyModerators external {\n', '        EnergyPackage storage pack = paidPackages[_packId];\n', '        pack.ethPrice = _ethPrice;\n', '        pack.emontPrice = _emontPrice;\n', '        pack.energy = _energy;\n', '    }\n', '    \n', '    function setConfig(address _paymentContract, uint _claimMaxAmount, uint _claimTime, uint _claimAmount) onlyModerators external {\n', '        paymentContract = _paymentContract;\n', '        claimMaxAmount = _claimMaxAmount;\n', '        claimTime = _claimTime;\n', '        claimAmount = _claimAmount;\n', '    }\n', '    \n', '    function topupEnergyByToken(address _player, uint _packId, uint _token) requirePaymentContract external {\n', '        if (msg.sender != paymentContract) revert();\n', '        EnergyPackage storage pack = paidPackages[_packId];\n', '        if (pack.energy == 0 || pack.emontPrice != _token)\n', '            revert();\n', '\n', '        Energy storage energy = energyData[_player];\n', '        energy.paidAmount += pack.energy;\n', '        \n', '        EventEnergyUpdate(_player, energy.freeAmount, energy.paidAmount, energy.lastClaim);\n', '    }\n', '    \n', '    // public update\n', '    \n', '    function safeDeduct(uint _a, uint _b) pure public returns(uint) {\n', '        if (_a < _b) return 0;\n', '        return (_a - _b);\n', '    }\n', '    \n', '    function topupEnergy(uint _packId) isActive payable external {\n', '        EnergyPackage storage pack = paidPackages[_packId];\n', '        if (pack.energy == 0 || pack.ethPrice != msg.value)\n', '            revert();\n', '\n', '        Energy storage energy = energyData[msg.sender];\n', '        energy.paidAmount += pack.energy;\n', '        \n', '        EventEnergyUpdate(msg.sender, energy.freeAmount, energy.paidAmount, energy.lastClaim);\n', '    }\n', '    \n', '    function claimEnergy() isActive external {\n', '        Energy storage energy = energyData[msg.sender];\n', '        uint period = safeDeduct(block.timestamp, energy.lastClaim);\n', '        uint energyAmount = (period / claimTime) * claimAmount;\n', '        \n', '        if (energyAmount == 0) revert();\n', '        if (energyAmount > claimMaxAmount) energyAmount = claimMaxAmount;\n', '        \n', '        energy.freeAmount += energyAmount;\n', '        energy.lastClaim = block.timestamp;\n', '        \n', '        EventEnergyUpdate(msg.sender, energy.freeAmount, energy.paidAmount, energy.lastClaim);\n', '    }\n', '    \n', '    // public get\n', '    function getPlayerEnergy(address _player) constant external returns(uint freeAmount, uint paidAmount, uint lastClaim) {\n', '        Energy storage energy = energyData[_player];\n', '        return (energy.freeAmount, energy.paidAmount, energy.lastClaim);\n', '    }\n', '    \n', '    function getClaimableAmount(address _trainer) constant external returns(uint) {\n', '        Energy storage energy = energyData[_trainer];\n', '        uint period = safeDeduct(block.timestamp, energy.lastClaim);\n', '        uint energyAmount = (period / claimTime) * claimAmount;\n', '        if (energyAmount > claimMaxAmount) energyAmount = claimMaxAmount;\n', '        return energyAmount;\n', '    }\n', '}']
