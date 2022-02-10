['pragma solidity ^0.4.11;\n', '\n', 'contract SafeMath {\n', '  function safeMul(uint a, uint b) internal returns (uint) {\n', '    uint c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function safeDiv(uint a, uint b) internal returns (uint) {\n', '    assert(b > 0);\n', '    uint c = a / b;\n', '    assert(a == b * c + a % b);\n', '    return c;\n', '  }\n', '\n', '  function safeSub(uint a, uint b) internal returns (uint) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function safeAdd(uint a, uint b) internal returns (uint) {\n', '    uint c = a + b;\n', '    assert(c>=a && c>=b);\n', '    return c;\n', '  }\n', '\n', '  function max64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min64(uint64 a, uint64 b) internal constant returns (uint64) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function max256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a >= b ? a : b;\n', '  }\n', '\n', '  function min256(uint256 a, uint256 b) internal constant returns (uint256) {\n', '    return a < b ? a : b;\n', '  }\n', '\n', '  function assert(bool assertion) internal {\n', '    if (!assertion) {\n', '      throw;\n', '    }\n', '  }\n', '}\n', '\n', 'contract Owned {\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    address public owner;\n', '\n', '    function Owned() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    address public newOwner;\n', '\n', '    function changeOwner(address _newOwner) onlyOwner {\n', '        newOwner = _newOwner;\n', '    }\n', '\n', '    function acceptOwnership() {\n', '        if (msg.sender == newOwner) {\n', '            owner = newOwner;\n', '        }\n', '    }\n', '}\n', '\n', '\n', 'contract SphereTokenFactory{\n', '\tfunction mint(address target, uint amount);\n', '}\n', '/*\n', ' * Haltable\n', ' *\n', ' * Abstract contract that allows children to implement an\n', ' * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.\n', ' *\n', ' *\n', ' * Originally envisioned in FirstBlood ICO contract.\n', ' */\n', 'contract Haltable is Owned {\n', '  bool public halted;\n', '\n', '  modifier stopInEmergency {\n', '    if (halted) throw;\n', '    _;\n', '  }\n', '\n', '  modifier onlyInEmergency {\n', '    if (!halted) throw;\n', '    _;\n', '  }\n', '\n', '  // called by the owner on emergency, triggers stopped state\n', '  function halt() external onlyOwner {\n', '    halted = true;\n', '  }\n', '\n', '  // called by the owner on end of emergency, returns to normal state\n', '  function unhalt() external onlyOwner onlyInEmergency {\n', '    halted = false;\n', '  }\n', '\n', '}\n', '\n', 'contract PricingMechanism is Haltable, SafeMath{\n', '    uint public decimals;\n', '    PriceTier[] public priceList;\n', '    uint8 public numTiers;\n', '    uint public currentTierIndex;\n', '    uint public totalDepositedEthers;\n', '    \n', '    struct  PriceTier {\n', '        uint costPerToken;\n', '        uint ethersDepositedInTier;\n', '        uint maxEthersInTier;\n', '    }\n', '    function setPricing() onlyOwner{\n', '        uint factor = 10 ** decimals;\n', '        priceList.push(PriceTier(uint(safeDiv(1 ether, 100 * factor)),0,5000 ether));\n', '        priceList.push(PriceTier(uint((1 ether - (10 wei * factor)) / (90 * factor)),0,5000 ether));\n', '        priceList.push(PriceTier(uint(1 ether / (80* factor)),0,5000 ether));\n', '        priceList.push(PriceTier(uint((1 ether - (50 wei * factor)) / (70* factor)),0,5000 ether));\n', '        priceList.push(PriceTier(uint((1 ether - (40 wei * factor)) / (60* factor)),0,5000 ether));\n', '        priceList.push(PriceTier(uint(1 ether / (50* factor)),0,5000 ether));\n', '        priceList.push(PriceTier(uint(1 ether / (40* factor)),0,5000 ether));\n', '        priceList.push(PriceTier(uint((1 ether - (10 wei * factor))/ (30* factor)),0,5000 ether));\n', '        priceList.push(PriceTier(uint((1 ether - (10 wei * factor))/ (15* factor)),0,30000 ether));\n', '        numTiers = 9;\n', '    }\n', '    function allocateTokensInternally(uint value) internal constant returns(uint numTokens){\n', '        if (numTiers == 0) return 0;\n', '        numTokens = 0;\n', '        uint8 tierIndex = 0;\n', '        for (uint8 i = 0; i < numTiers; i++){\n', '            if (priceList[i].ethersDepositedInTier < priceList[i].maxEthersInTier){\n', '                uint ethersToDepositInTier = min256(priceList[i].maxEthersInTier - priceList[i].ethersDepositedInTier, value);\n', '                numTokens = safeAdd(numTokens, ethersToDepositInTier / priceList[i].costPerToken);\n', '                priceList[i].ethersDepositedInTier = safeAdd(ethersToDepositInTier, priceList[i].ethersDepositedInTier);\n', '                totalDepositedEthers = safeAdd(ethersToDepositInTier, totalDepositedEthers);\n', '                value = safeSub(value, ethersToDepositInTier);\n', '                if (priceList[i].ethersDepositedInTier > 0)\n', '                    tierIndex = i;\n', '            }\n', '        }\n', '        currentTierIndex = tierIndex;\n', '        return numTokens;\n', '    }\n', '    \n', '}\n', '\n', 'contract DAOController{\n', '    address public dao;\n', '    modifier onlyDAO{\n', '        if (msg.sender != dao) throw;\n', '        _;\n', '    }\n', '}\n', '\n', 'contract CrowdSale is PricingMechanism, DAOController{\n', '    SphereTokenFactory public tokenFactory;\n', '    uint public hardCapAmount;\n', '    bool public isStarted = false;\n', '    bool public isFinalized = false;\n', '    uint public duration = 30 days;\n', '    uint public startTime;\n', '    address public multiSig;\n', '    bool public finalizeSet = false;\n', '    \n', '    modifier onlyStarted{\n', '        if (!isStarted) throw;\n', '        _;\n', '    }\n', '    modifier notFinalized{\n', '        if (isFinalized) throw;\n', '        _;\n', '    }\n', '    modifier afterFinalizeSet{\n', '        if (!finalizeSet) throw;\n', '        _;\n', '    }\n', '    function CrowdSale(){\n', '        tokenFactory = SphereTokenFactory(0xf961eb0acf690bd8f92c5f9c486f3b30848d87aa);\n', '        decimals = 4;\n', '        setPricing();\n', '        hardCapAmount = 75000 ether;\n', '    }\n', '    function startCrowdsale() onlyOwner {\n', '        if (isStarted) throw;\n', '        isStarted = true;\n', '        startTime = now;\n', '    }\n', '    function setDAOAndMultiSig(address _dao, address _multiSig) onlyOwner{\n', '        dao = _dao;\n', '        multiSig = _multiSig;\n', '        finalizeSet = true;\n', '    }\n', '    function() payable stopInEmergency onlyStarted notFinalized{\n', '        if (totalDepositedEthers >= hardCapAmount) throw;\n', '        uint contribution = msg.value;\n', '        if (safeAdd(totalDepositedEthers, msg.value) > hardCapAmount){\n', '            contribution = safeSub(hardCapAmount, totalDepositedEthers);\n', '        }\n', '        uint excess = safeSub(msg.value, contribution);\n', '        uint numTokensToAllocate = allocateTokensInternally(contribution);\n', '        tokenFactory.mint(msg.sender, numTokensToAllocate);\n', '        if (excess > 0){\n', '            msg.sender.send(excess);\n', '        }\n', '    }\n', '    \n', '    function finalize() payable onlyOwner afterFinalizeSet{\n', '        if (hardCapAmount == totalDepositedEthers || (now - startTime) > duration){\n', '            dao.call.gas(150000).value(totalDepositedEthers * 3 / 10)();\n', '            multiSig.call.gas(150000).value(this.balance)();\n', '            isFinalized = true;\n', '        }\n', '    }\n', '    function emergencyCease() payable onlyStarted onlyInEmergency onlyOwner afterFinalizeSet{\n', '        isFinalized = true;\n', '        isStarted = false;\n', '        multiSig.call.gas(150000).value(this.balance)();\n', '    }\n', '}']