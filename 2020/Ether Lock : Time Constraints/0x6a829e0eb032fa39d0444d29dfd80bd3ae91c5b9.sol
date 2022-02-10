['pragma solidity >=0.5.0 <0.6.0;\n', '\n', 'library DSMath {\n', '    function add(uint x, uint y) internal pure returns (uint z) {\n', '        require((z = x + y) >= x, "ds-math-add-overflow");\n', '    }\n', '    function sub(uint x, uint y) internal pure returns (uint z) {\n', '        require((z = x - y) <= x, "ds-math-sub-underflow");\n', '    }\n', '    function mul(uint x, uint y) internal pure returns (uint z) {\n', '        require(y == 0 || (z = x * y) / y == x, "ds-math-mul-overflow");\n', '    }\n', '    function div(uint x, uint y) internal pure returns (uint z) {\n', '        // assert(y > 0); // Solidity automatically throws when dividing by 0\n', '        z = x / y;\n', "        // assert(x == y * z + x % y); // There is no case in which this doesn't hold\n", '    }\n', '\n', '    function min(uint x, uint y) internal pure returns (uint z) {\n', '        return x <= y ? x : y;\n', '    }\n', '    function max(uint x, uint y) internal pure returns (uint z) {\n', '        return x >= y ? x : y;\n', '    }\n', '    function imin(int x, int y) internal pure returns (int z) {\n', '        return x <= y ? x : y;\n', '    }\n', '    function imax(int x, int y) internal pure returns (int z) {\n', '        return x >= y ? x : y;\n', '    }\n', '\n', '    uint constant WAD = 10 ** 18;\n', '    uint constant RAY = 10 ** 27;\n', '\n', '    function wmul(uint x, uint y) internal pure returns (uint z) {\n', '        z = add(mul(x, y), WAD / 2) / WAD;\n', '    }\n', '    function rmul(uint x, uint y) internal pure returns (uint z) {\n', '        z = add(mul(x, y), RAY / 2) / RAY;\n', '    }\n', '    function wdiv(uint x, uint y) internal pure returns (uint z) {\n', '        z = add(mul(x, WAD), y / 2) / y;\n', '    }\n', '    function rdiv(uint x, uint y) internal pure returns (uint z) {\n', '        z = add(mul(x, RAY), y / 2) / y;\n', '    }\n', '\n', '    // This famous algorithm is called "exponentiation by squaring"\n', '    // and calculates x^n with x as fixed-point and n as regular unsigned.\n', '    //\n', "    // It's O(log n), instead of O(n) for naive repeated multiplication.\n", '    //\n', '    // These facts are why it works:\n', '    //\n', '    //  If n is even, then x^n = (x^2)^(n/2).\n', '    //  If n is odd,  then x^n = x * x^(n-1),\n', '    //   and applying the equation for even x gives\n', '    //    x^n = x * (x^2)^((n-1) / 2).\n', '    //\n', '    //  Also, EVM division is flooring and\n', '    //    floor[(n-1) / 2] = floor[n / 2].\n', '    //\n', '    function rpow(uint x, uint n) internal pure returns (uint z) {\n', '        z = n % 2 != 0 ? x : RAY;\n', '\n', '        for (n /= 2; n != 0; n /= 2) {\n', '            x = rmul(x, x);\n', '\n', '            if (n % 2 != 0) {\n', '                z = rmul(z, x);\n', '            }\n', '        }\n', '    }\n', '}\n', '\n', '/**\n', ' * @title Staking and delegation contract\n', ' * @author DOS Network\n', ' */\n', '\n', 'contract ERC20I {\n', '    function balanceOf(address who) public view returns (uint);\n', '    function decimals() public view returns (uint);\n', '    function transfer(address to, uint value) public returns (bool);\n', '    function transferFrom(address from, address to, uint value) public returns (bool);\n', '    function approve(address spender, uint value) public returns (bool);\n', '}\n', '\n', 'contract DOSAddressBridgeInterface {\n', '    function getProxyAddress() public view returns(address);\n', '}\n', '\n', 'contract Staking {\n', '    using DSMath for *;\n', '\n', '    uint public constant ONEYEAR = 365 days;\n', '    uint public constant DOSDECIMAL = 18;\n', '    uint public constant DBDECIMAL = 0;\n', '    uint public constant LISTHEAD = 0x1;\n', '    uint public initBlkN;\n', '    address public admin;\n', '    address public DOSTOKEN;\n', '    address public DBTOKEN ;\n', '    address public stakingRewardsVault;\n', '    address public bridgeAddr;  // DOS address bridge\n', '    uint public minStakePerNode;\n', '    uint public dropburnMaxQuota;\n', '    uint public totalStakedTokens;\n', '    uint public circulatingSupply;\n', '    uint public unbondDuration;\n', '    uint public lastRateUpdatedTime;    // in seconds\n', '    uint public accumulatedRewardIndex; // Multiplied by 1e10\n', '\n', '    struct Node {\n', '        address ownerAddr;\n', '        uint rewardCut;  // %, [0, 100).\n', '        uint stakedDB;   // [0, dropburnMaxQuota]\n', '        uint selfStakedAmount;\n', '        uint totalOtherDelegatedAmount;\n', '        uint accumulatedRewards;\n', '        uint accumulatedRewardIndex;\n', '        uint pendingWithdrawToken;\n', '        uint pendingWithdrawDB;\n', '        uint lastStartTime;\n', '        bool running;\n', '        string description;\n', '        address[] nodeDelegators;\n', '        // release time => UnbondRequest metadata\n', '        mapping (uint => UnbondRequest) unbondRequests;\n', '        // LISTHEAD => release time 1 => ... => release time m => LISTHEAD\n', '        mapping (uint => uint) releaseTime;\n', '        string logoUrl;\n', '    }\n', '\n', '    struct UnbondRequest {\n', '        uint dosAmount;\n', '        uint dbAmount;\n', '    }\n', '\n', '    struct Delegation {\n', '        address delegatedNode;\n', '        uint delegatedAmount;\n', '        uint accumulatedRewards; // in tokens\n', '        uint accumulatedRewardIndex;\n', '        uint pendingWithdraw;\n', '\n', '        // release time => UnbondRequest metadata\n', '        mapping (uint => UnbondRequest) unbondRequests;\n', '        // LISTHEAD => release time 1 => ... => release time m => LISTHEAD\n', '        mapping (uint => uint) releaseTime;\n', '    }\n', '\n', '    // 1:1 node address => Node metadata\n', '    mapping (address => Node) public nodes;\n', '    address[] public nodeAddrs;\n', '\n', "    // node runner's main address => {node addresses}\n", '    mapping (address => mapping(address => bool)) public nodeRunners;\n', '    // 1:n token holder address => {delegated node 1 : Delegation, ..., delegated node n : Delegation}\n', '    mapping (address => mapping(address => Delegation)) public delegators;\n', '\n', '    event UpdateStakingAdmin(address oldAdmin, address newAdmin);\n', '    event UpdateDropBurnMaxQuota(uint oldQuota, uint newQuota);\n', '    event UpdateUnbondDuration(uint oldDuration, uint newDuration);\n', '    event UpdateCirculatingSupply(uint oldCirculatingSupply, uint newCirculatingSupply);\n', '    event UpdateMinStakePerNode(uint oldMinStakePerNode, uint newMinStakePerNode);\n', '    event NewNode(address indexed owner, address indexed nodeAddress, uint selfStakedAmount, uint stakedDB, uint rewardCut);\n', '    event Delegate(address indexed from, address indexed to, uint amount);\n', '    event Withdraw(address indexed from, address indexed to, bool nodeRunner, uint tokenAmount, uint dbAmount);\n', '    event Unbond(address indexed from, address indexed to, bool nodeRunner, uint tokenAmount, uint dropburnAmount);\n', '    event ClaimReward(address indexed to, bool nodeRunner, uint amount);\n', '\n', '    constructor(address _dostoken, address _dbtoken, address _vault, address _bridgeAddr) public {\n', '        initialize(_dostoken, _dbtoken, _vault, _bridgeAddr);\n', '    }\n', '\n', '    function initialize(address _dostoken, address _dbtoken, address _vault, address _bridgeAddr) public {\n', '        require(initBlkN == 0, "already-initialized");\n', '\n', '        initBlkN = block.number;\n', '        admin = msg.sender;\n', '        DOSTOKEN = _dostoken;\n', '        DBTOKEN = _dbtoken;\n', '        stakingRewardsVault = _vault;\n', '        bridgeAddr = _bridgeAddr;\n', '        minStakePerNode = 800000 * (10 ** DOSDECIMAL);\n', '        dropburnMaxQuota = 3;\n', '        circulatingSupply = 160000000 * (10 ** DOSDECIMAL);\n', '        unbondDuration = 7 days;\n', '    }\n', '\n', '    modifier onlyAdmin {\n', '        require(msg.sender == admin, "onlyAdmin");\n', '        _;\n', '    }\n', '\n', '    function setAdmin(address newAdmin) public onlyAdmin {\n', '        require(newAdmin != address(0));\n', '        emit UpdateStakingAdmin(admin, newAdmin);\n', '        admin = newAdmin;\n', '    }\n', '\n', '    /// @dev used when drop burn max quota duration is changed\n', '    function setDropBurnMaxQuota(uint _quota) public onlyAdmin {\n', '        require(_quota != dropburnMaxQuota && _quota < 10, "valid-dropburnMaxQuota-0-to-9");\n', '        emit UpdateDropBurnMaxQuota(dropburnMaxQuota, _quota);\n', '        dropburnMaxQuota = _quota;\n', '    }\n', '\n', '    /// @dev used when withdraw duration is changed\n', '    function setUnbondDuration(uint _duration) public onlyAdmin {\n', '        emit UpdateUnbondDuration(unbondDuration, _duration);\n', '        unbondDuration = _duration;\n', '    }\n', '\n', '    /// @dev used when locked token is unlocked\n', '    function setCirculatingSupply(uint _newSupply) public onlyAdmin {\n', '        require(circulatingSupply >= totalStakedTokens,"CirculatingSupply < totalStakedTokens");\n', '\n', '        updateGlobalRewardIndex();\n', '        emit UpdateCirculatingSupply(circulatingSupply, _newSupply);\n', '        circulatingSupply = _newSupply;\n', '    }\n', '\n', '    /// @dev used when minStakePerNode is updated\n', '    function setMinStakePerNode(uint _minStake) public onlyAdmin {\n', '        emit UpdateMinStakePerNode(minStakePerNode, _minStake);\n', '        minStakePerNode = _minStake;\n', '    }\n', '\n', '    function getNodeAddrs() public view returns(address[] memory) {\n', '        return nodeAddrs;\n', '    }\n', '\n', '    modifier checkStakingValidity(uint _tokenAmount, uint _dropburnAmount, uint _rewardCut) {\n', '        require(0 <= _rewardCut && _rewardCut < 100, "not-valid-rewardCut-in-0-to-99");\n', '        require(_tokenAmount >= minStakePerNode.mul(10.sub(DSMath.min(_dropburnAmount, dropburnMaxQuota))).div(10),\n', '                "not-enough-dos-token-to-start-node");\n', '        _;\n', '    }\n', '\n', '    modifier onlyFromProxy() {\n', '        require(msg.sender == DOSAddressBridgeInterface(bridgeAddr).getProxyAddress(), "not-from-dos-proxy");\n', '        _;\n', '    }\n', '\n', '    function isValidStakingNode(address nodeAddr) public view returns(bool) {\n', '        Node storage node = nodes[nodeAddr];\n', '        uint _tokenAmount = node.selfStakedAmount;\n', '        uint _dropburnAmount = node.stakedDB;\n', '        if (_tokenAmount >= minStakePerNode.mul(10.sub(DSMath.min(_dropburnAmount, dropburnMaxQuota))).div(10)) {\n', '            return true;\n', '        }\n', '        return false;\n', '    }\n', '\n', '    function newNode(\n', '        address _nodeAddr,\n', '        uint _tokenAmount,\n', '        uint _dropburnAmount,\n', '        uint _rewardCut,\n', '        string memory _desc,\n', '        string memory _logoUrl)\n', '        public checkStakingValidity(_tokenAmount, _dropburnAmount, _rewardCut)\n', '    {\n', '        require(!nodeRunners[msg.sender][_nodeAddr], "node-already-registered");\n', '        require(nodes[_nodeAddr].ownerAddr == address(0), "node-already-registered");\n', '\n', '        nodeRunners[msg.sender][_nodeAddr] = true;\n', '        address[] memory nodeDelegators;\n', '        nodes[_nodeAddr] = Node(msg.sender, _rewardCut, _dropburnAmount, _tokenAmount, 0, 0, 0, 0, 0, 0, false, _desc, nodeDelegators, _logoUrl);\n', '        nodes[_nodeAddr].releaseTime[LISTHEAD] = LISTHEAD;\n', '        nodeAddrs.push(_nodeAddr);\n', '        // This would change interest rate\n', '        totalStakedTokens = totalStakedTokens.add(_tokenAmount);\n', '        // Deposit tokens.\n', '        ERC20I(DOSTOKEN).transferFrom(msg.sender, address(this), _tokenAmount);\n', '        if (_dropburnAmount > 0) {\n', '            ERC20I(DBTOKEN).transferFrom(msg.sender, address(this), _dropburnAmount);\n', '        }\n', '        emit NewNode(msg.sender, _nodeAddr, _tokenAmount, _dropburnAmount, _rewardCut);\n', '    }\n', '\n', '    function nodeStart(address _nodeAddr) public onlyFromProxy {\n', '        require(nodes[_nodeAddr].ownerAddr != address(0), "node-not-registered");\n', '        Node storage node = nodes[_nodeAddr];\n', '        if (!node.running) {\n', '            node.running = true;\n', '            node.lastStartTime = now;\n', '            updateGlobalRewardIndex();\n', '            node.accumulatedRewardIndex = accumulatedRewardIndex;\n', '            for (uint i = 0; i < node.nodeDelegators.length; i++) {\n', '                Delegation storage delegator = delegators[node.nodeDelegators[i]][_nodeAddr];\n', '                delegator.accumulatedRewardIndex = accumulatedRewardIndex;\n', '            }\n', '        }\n', '    }\n', '\n', '    function nodeStop(address _nodeAddr) public onlyFromProxy {\n', '        require(nodes[_nodeAddr].ownerAddr != address(0), "node-not-registered");\n', '        nodeStopInternal(_nodeAddr);\n', '    }\n', '\n', '    function nodeStopInternal(address _nodeAddr) internal {\n', '        Node storage node = nodes[_nodeAddr];\n', '        if (node.running) {\n', '            updateGlobalRewardIndex();\n', '            node.accumulatedRewards = getNodeRewardTokens(_nodeAddr);\n', '            node.accumulatedRewardIndex = accumulatedRewardIndex;\n', '            for (uint i = 0; i < node.nodeDelegators.length; i++) {\n', '                Delegation storage delegator = delegators[node.nodeDelegators[i]][_nodeAddr];\n', '                delegator.accumulatedRewards = getDelegatorRewardTokens(node.nodeDelegators[i], _nodeAddr);\n', '                delegator.accumulatedRewardIndex = accumulatedRewardIndex;\n', '            }\n', '            node.running = false;\n', '        }\n', '    }\n', '\n', '    // For node runners to configure new staking settings.\n', '    function updateNodeStaking(\n', '        address _nodeAddr,\n', '        uint _newTokenAmount,\n', '        uint _newDropburnAmount,\n', '        uint _newCut,\n', '        string memory _newDesc,\n', '        string memory _newLogoUrl)\n', '        public\n', '    {\n', '        require(nodeRunners[msg.sender][_nodeAddr], "node-not-owned-by-msgSender");\n', '\n', '        Node storage node = nodes[_nodeAddr];\n', '        // _newCut with value uint(-1) means skipping this config.\n', '        if (_newCut != uint(-1)) {\n', '            require(_newCut >= 0 && _newCut < 100, "not-valid-rewardCut-in-0-to-99");\n', "            // TODO: Update rewardCut affects delegators' reward calculation.\n", '            node.rewardCut = _newCut;\n', '        }\n', '        if (_newDropburnAmount != 0) {\n', '            node.stakedDB = node.stakedDB.add(_newDropburnAmount);\n', '            ERC20I(DBTOKEN).transferFrom(msg.sender, address(this), _newDropburnAmount);\n', '        }\n', '        if (_newTokenAmount != 0) {\n', '            node.selfStakedAmount = node.selfStakedAmount.add(_newTokenAmount);\n', '            if (node.running) {\n', '                // Update global accumulated interest index.\n', '                updateGlobalRewardIndex();\n', '                node.accumulatedRewards = getNodeRewardTokens(_nodeAddr);\n', '                node.accumulatedRewardIndex = accumulatedRewardIndex;\n', '            }\n', '            // This would change interest rate\n', '            totalStakedTokens = totalStakedTokens.add(_newTokenAmount);\n', '            ERC20I(DOSTOKEN).transferFrom(msg.sender, address(this), _newTokenAmount);\n', '        }\n', '        if (bytes(_newDesc).length > 0 && bytes(_newDesc).length <= 32) {\n', '            node.description = _newDesc;\n', '        }\n', '        if (bytes(_newLogoUrl).length > 0) {\n', '            node.logoUrl = _newLogoUrl;\n', '        }\n', '    }\n', '\n', "    // Token holders (delegators) call this function. It's allowed to delegate to the same node multiple times if possible.\n", '    // Note: Re-delegate is not supported.\n', '    function delegate(uint _tokenAmount, address _nodeAddr) public {\n', '        Node storage node = nodes[_nodeAddr];\n', '        require(node.ownerAddr != address(0), "node-not-exist");\n', '        require(msg.sender != node.ownerAddr, "node-owner-cannot-self-delegate");\n', '\n', '        Delegation storage delegator = delegators[msg.sender][_nodeAddr];\n', '        require(delegator.delegatedNode == address(0) || delegator.delegatedNode == _nodeAddr, "invalid-delegated-node-addr");\n', '\n', '        node.nodeDelegators.push(msg.sender);\n', '        node.totalOtherDelegatedAmount = node.totalOtherDelegatedAmount.add(_tokenAmount);\n', '        if (node.running) {\n', '            // Update global accumulated interest index.\n', '            updateGlobalRewardIndex();\n', '            node.accumulatedRewards = getNodeRewardTokens(_nodeAddr);\n', '            node.accumulatedRewardIndex = accumulatedRewardIndex;\n', '            delegator.accumulatedRewards = getDelegatorRewardTokens(msg.sender, _nodeAddr);\n', '            delegator.accumulatedRewardIndex = accumulatedRewardIndex;\n', '        }\n', '        delegator.delegatedAmount = delegator.delegatedAmount.add(_tokenAmount);\n', '        if (delegator.delegatedNode == address(0)) {\n', '            // New delegation\n', '            delegator.delegatedNode = _nodeAddr;\n', '            delegator.releaseTime[LISTHEAD] = LISTHEAD;\n', '        }\n', '        // This would change interest rate\n', '        totalStakedTokens = totalStakedTokens.add(_tokenAmount);\n', '        ERC20I(DOSTOKEN).transferFrom(msg.sender, address(this), _tokenAmount);\n', '        emit Delegate(msg.sender, _nodeAddr, _tokenAmount);\n', '    }\n', '\n', '    function nodeUnregister(address _nodeAddr) public {\n', '        require(nodeRunners[msg.sender][_nodeAddr], "node-not-owned-by-msgSender");\n', '        Node storage node = nodes[_nodeAddr];\n', '        nodeStopInternal(_nodeAddr);\n', '        nodeUnbondInternal(node.selfStakedAmount, node.stakedDB, _nodeAddr);\n', '    }\n', '\n', '    function nodeTryDelete(address _nodeAddr) internal {\n', '        if (!nodes[_nodeAddr].running &&\n', '            nodes[_nodeAddr].selfStakedAmount == 0 &&\n', '            nodes[_nodeAddr].stakedDB == 0 &&\n', '            nodes[_nodeAddr].totalOtherDelegatedAmount == 0 &&\n', '            nodes[_nodeAddr].accumulatedRewards == 0 &&\n', '            nodes[_nodeAddr].nodeDelegators.length == 0 &&\n', '            nodes[_nodeAddr].pendingWithdrawToken == 0 &&\n', '            nodes[_nodeAddr].pendingWithdrawDB == 0\n', '        ) {\n', '            delete nodeRunners[nodes[_nodeAddr].ownerAddr][_nodeAddr];\n', '            delete nodes[_nodeAddr];\n', '            for (uint idx = 0; idx < nodeAddrs.length; idx++) {\n', '                if (nodeAddrs[idx] == _nodeAddr) {\n', '                    nodeAddrs[idx] = nodeAddrs[nodeAddrs.length - 1];\n', '                    nodeAddrs.length--;\n', '                    return;\n', '                }\n', '            }\n', '        }\n', '    }\n', '    // Used by node runners to unbond their stakes.\n', "    // Unbonded tokens are locked for 7 days, during the unbonding period they're not eligible for staking rewards.\n", '    function nodeUnbond(uint _tokenAmount, uint _dropburnAmount, address _nodeAddr) public {\n', '        require(nodeRunners[msg.sender][_nodeAddr], "node-not-owned-by-msgSender");\n', '        Node storage node = nodes[_nodeAddr];\n', '\n', '        require(_tokenAmount <= node.selfStakedAmount, "invalid-to-unbond-more-than-staked-amount");\n', '        require(_dropburnAmount <= node.stakedDB, "invalid-to-unbond-more-than-staked-DropBurn-amount");\n', '        require(node.selfStakedAmount.sub(_tokenAmount) >=\n', '                minStakePerNode.mul(10.sub(DSMath.min(node.stakedDB.sub(_dropburnAmount), dropburnMaxQuota))).div(10),\n', '                "invalid-unbond-to-maintain-staking-requirement");\n', '        nodeUnbondInternal(_tokenAmount, _dropburnAmount, _nodeAddr);\n', '    }\n', '    // Used by node runners to unbond their stakes.\n', "    // Unbonded tokens are locked for 7 days, during the unbonding period they're not eligible for staking rewards.\n", '    function nodeUnbondInternal(uint _tokenAmount, uint _dropburnAmount, address _nodeAddr) internal {\n', '        require(nodeRunners[msg.sender][_nodeAddr], "node-not-owned-by-msgSender");\n', '        Node storage node = nodes[_nodeAddr];\n', '        if (node.running) {\n', '            updateGlobalRewardIndex();\n', '            node.accumulatedRewards = getNodeRewardTokens(_nodeAddr);\n', '            node.accumulatedRewardIndex = accumulatedRewardIndex;\n', '        }\n', '        // This would change interest rate\n', '        totalStakedTokens = totalStakedTokens.sub(_tokenAmount);\n', '        node.selfStakedAmount = node.selfStakedAmount.sub(_tokenAmount);\n', '        node.pendingWithdrawToken = node.pendingWithdrawToken.add(_tokenAmount);\n', '        node.stakedDB = node.stakedDB.sub(_dropburnAmount);\n', '        node.pendingWithdrawDB = node.pendingWithdrawDB.add(_dropburnAmount);\n', '\n', '        if (_tokenAmount > 0 || _dropburnAmount > 0) {\n', '            // create an UnbondRequest\n', '            uint releaseTime = now.add(unbondDuration);\n', '            node.unbondRequests[releaseTime] = UnbondRequest(_tokenAmount, _dropburnAmount);\n', '            node.releaseTime[releaseTime] = node.releaseTime[LISTHEAD];\n', '            node.releaseTime[LISTHEAD] = releaseTime;\n', '        }\n', '\n', '        emit Unbond(msg.sender, _nodeAddr, true, _tokenAmount, _dropburnAmount);\n', '    }\n', '\n', '    // Used by token holders (delegators) to unbond their delegations.\n', '    function delegatorUnbond(uint _tokenAmount, address _nodeAddr) public {\n', '        Delegation storage delegator = delegators[msg.sender][_nodeAddr];\n', '        require(nodes[_nodeAddr].ownerAddr != address(0), "node-not-exist");\n', '        require(delegator.delegatedNode == _nodeAddr, "invalid-unbond-from-non-delegated-node");\n', '        require(_tokenAmount <= delegator.delegatedAmount, "invalid-unbond-more-than-delegated-amount");\n', '        if (nodes[_nodeAddr].running) {\n', '            updateGlobalRewardIndex();\n', '            delegator.accumulatedRewards = getDelegatorRewardTokens(msg.sender, _nodeAddr);\n', '            delegator.accumulatedRewardIndex = accumulatedRewardIndex;\n', '            nodes[_nodeAddr].accumulatedRewards = getNodeRewardTokens(_nodeAddr);\n', '            nodes[_nodeAddr].accumulatedRewardIndex = accumulatedRewardIndex;\n', '        }\n', '        // This would change interest rate\n', '        totalStakedTokens = totalStakedTokens.sub(_tokenAmount);\n', '        delegator.delegatedAmount = delegator.delegatedAmount.sub(_tokenAmount);\n', '        delegator.pendingWithdraw = delegator.pendingWithdraw.add(_tokenAmount);\n', '        nodes[_nodeAddr].totalOtherDelegatedAmount = nodes[_nodeAddr].totalOtherDelegatedAmount.sub(_tokenAmount);\n', '\n', '        if (_tokenAmount > 0) {\n', '            // create a UnbondRequest\n', '            uint releaseTime = now.add(unbondDuration);\n', '            delegator.unbondRequests[releaseTime] = UnbondRequest(_tokenAmount, 0);\n', '            delegator.releaseTime[releaseTime] = delegator.releaseTime[LISTHEAD];\n', '            delegator.releaseTime[LISTHEAD] = releaseTime;\n', '        }\n', '\n', '        emit Unbond(msg.sender, _nodeAddr, false, _tokenAmount, 0);\n', '    }\n', '\n', '    function withdrawAll(mapping(uint => uint) storage releaseTimeList, mapping(uint => UnbondRequest) storage requestList)\n', '        internal\n', '        returns(uint, uint)\n', '    {\n', '        uint accumulatedDos = 0;\n', '        uint accumulatedDropburn = 0;\n', '        uint prev = LISTHEAD;\n', '        uint curr = releaseTimeList[prev];\n', '        while (curr != LISTHEAD && curr > now) {\n', '            prev = curr;\n', '            curr = releaseTimeList[prev];\n', '        }\n', '        if (releaseTimeList[prev] != LISTHEAD) {\n', '            releaseTimeList[prev] = LISTHEAD;\n', '        }\n', '        // All next items are withdrawable.\n', '        while (curr != LISTHEAD) {\n', '            accumulatedDos = accumulatedDos.add(requestList[curr].dosAmount);\n', '            accumulatedDropburn = accumulatedDropburn.add(requestList[curr].dbAmount);\n', '            prev = curr;\n', '            curr = releaseTimeList[prev];\n', '            delete releaseTimeList[prev];\n', '            delete requestList[prev];\n', '        }\n', '        return (accumulatedDos, accumulatedDropburn);\n', '    }\n', '\n', '    /// @dev A view version of above call with equivalent functionality, used by other view functions.\n', '    function withdrawable(mapping(uint => uint) storage releaseTimeList, mapping(uint => UnbondRequest) storage requestList)\n', '        internal\n', '        view\n', '        returns(uint, uint)\n', '    {\n', '        uint accumulatedDos = 0;\n', '        uint accumulatedDropburn = 0;\n', '        uint prev = LISTHEAD;\n', '        uint curr = releaseTimeList[prev];\n', '        while (curr != LISTHEAD && curr > now) {\n', '            prev = curr;\n', '            curr = releaseTimeList[prev];\n', '        }\n', '        // All next items are withdrawable.\n', '        while (curr != LISTHEAD) {\n', '            accumulatedDos = accumulatedDos.add(requestList[curr].dosAmount);\n', '            accumulatedDropburn = accumulatedDropburn.add(requestList[curr].dbAmount);\n', '            prev = curr;\n', '            curr = releaseTimeList[prev];\n', '\n', '        }\n', '        return (accumulatedDos, accumulatedDropburn);\n', '    }\n', '\n', '    // Node runners call this function to withdraw available unbonded tokens after unbond period.\n', '    function nodeWithdraw(address _nodeAddr) public {\n', '        Node storage node = nodes[_nodeAddr];\n', '        require(node.ownerAddr == msg.sender, "non-owner-not-authorized-to-withdraw");\n', '\n', '        (uint tokenAmount, uint dropburnAmount) = withdrawAll(node.releaseTime, node.unbondRequests);\n', '        node.pendingWithdrawToken = node.pendingWithdrawToken.sub(tokenAmount);\n', '        node.pendingWithdrawDB = node.pendingWithdrawDB.sub(dropburnAmount);\n', '\n', '        nodeTryDelete(_nodeAddr);\n', '\n', '        if (tokenAmount > 0) {\n', '            ERC20I(DOSTOKEN).transfer(msg.sender, tokenAmount);\n', '        }\n', '        if (dropburnAmount > 0) {\n', '            ERC20I(DBTOKEN).transfer(msg.sender, dropburnAmount);\n', '        }\n', '        emit Withdraw(_nodeAddr, msg.sender, true, tokenAmount, dropburnAmount);\n', '    }\n', '\n', '    // Delegators call this function to withdraw available unbonded tokens from a specific node after unbond period.\n', '    function delegatorWithdraw(address _nodeAddr) public {\n', '        Delegation storage delegator = delegators[msg.sender][_nodeAddr];\n', '        require(nodes[_nodeAddr].ownerAddr != address(0), "node-not-exist");\n', '        require(delegator.delegatedNode == _nodeAddr, "cannot-withdraw-from-non-delegated-node");\n', '\n', '        (uint tokenAmount, ) = withdrawAll(delegator.releaseTime, delegator.unbondRequests);\n', '        if (tokenAmount > 0) {\n', '            delegator.pendingWithdraw = delegator.pendingWithdraw.sub(tokenAmount);\n', '            if (delegator.delegatedAmount == 0 && delegator.pendingWithdraw == 0 && delegator.accumulatedRewards == 0) {\n', '                delete delegators[msg.sender][_nodeAddr];\n', '                uint idx = 0;\n', '                for (; idx < nodes[_nodeAddr].nodeDelegators.length; idx++) {\n', '                    if (nodes[_nodeAddr].nodeDelegators[idx] == msg.sender) {\n', '                        break;\n', '                    }\n', '                }\n', '                if (idx < nodes[_nodeAddr].nodeDelegators.length) {\n', '                    nodes[_nodeAddr].nodeDelegators[idx] = nodes[_nodeAddr].nodeDelegators[nodes[_nodeAddr].nodeDelegators.length - 1];\n', '                    nodes[_nodeAddr].nodeDelegators.length--;\n', '                }\n', '                nodeTryDelete(_nodeAddr);\n', '            }\n', '\n', '            ERC20I(DOSTOKEN).transfer(msg.sender, tokenAmount);\n', '        }\n', '        emit Withdraw(_nodeAddr, msg.sender, false, tokenAmount, 0);\n', '    }\n', '\n', '    function nodeWithdrawable(address _owner, address _nodeAddr) public view returns(uint, uint) {\n', '        Node storage node = nodes[_nodeAddr];\n', '        if (node.ownerAddr != _owner) return (0, 0);\n', '        return withdrawable(node.releaseTime, node.unbondRequests);\n', '    }\n', '\n', '    function delegatorWithdrawable(address _owner, address _nodeAddr) public view returns(uint) {\n', '        Delegation storage delegator = delegators[_owner][_nodeAddr];\n', '        if (delegator.delegatedNode != _nodeAddr) return 0;\n', '        uint tokenAmount = 0;\n', '        (tokenAmount, ) = withdrawable(delegator.releaseTime, delegator.unbondRequests);\n', '        return tokenAmount;\n', '    }\n', '\n', '    function nodeClaimReward(address _nodeAddr) public {\n', '        Node storage node = nodes[_nodeAddr];\n', '        require(node.ownerAddr == msg.sender, "non-owner-not-authorized-to-claim");\n', '        updateGlobalRewardIndex();\n', '        uint claimedReward = getNodeRewardTokens(_nodeAddr);\n', '        node.accumulatedRewards = 0;\n', '        node.accumulatedRewardIndex = accumulatedRewardIndex;\n', '        // This would change interest rate\n', '        circulatingSupply = circulatingSupply.add(claimedReward);\n', '        ERC20I(DOSTOKEN).transferFrom(stakingRewardsVault, msg.sender, claimedReward);\n', '        emit ClaimReward(msg.sender, true, claimedReward);\n', '    }\n', '\n', '    function delegatorClaimReward(address _nodeAddr) public {\n', '        Delegation storage delegator = delegators[msg.sender][_nodeAddr];\n', '        require(nodes[_nodeAddr].ownerAddr != address(0), "node-not-exist");\n', '        require(delegator.delegatedNode == _nodeAddr, "cannot-claim-from-non-delegated-node");\n', '        updateGlobalRewardIndex();\n', '        uint claimedReward = getDelegatorRewardTokens(msg.sender, _nodeAddr);\n', '\n', '        if (delegator.delegatedAmount == 0 && delegator.pendingWithdraw == 0) {\n', '            delete delegators[msg.sender][_nodeAddr];\n', '        } else {\n', '            delegator.accumulatedRewards = 0;\n', '            delegator.accumulatedRewardIndex = accumulatedRewardIndex;\n', '        }\n', '        // This would change interest rate\n', '        circulatingSupply = circulatingSupply.add(claimedReward);\n', '        ERC20I(DOSTOKEN).transferFrom(stakingRewardsVault, msg.sender, claimedReward);\n', '        emit ClaimReward(msg.sender, false, claimedReward);\n', '    }\n', '\n', '    function getNodeUptime(address nodeAddr) public view returns(uint) {\n', '        Node storage node = nodes[nodeAddr];\n', '        if (node.running) {\n', '            return now.sub(node.lastStartTime);\n', '        } else {\n', '            return 0;\n', '        }\n', '    }\n', '\n', '    // return a percentage in [4.00, 80.00] (400, 8000)\n', '    function getCurrentAPR() public view returns (uint) {\n', '        if (totalStakedTokens == 0) {\n', '            return 8000;\n', '        }\n', '        uint localinverseStakeRatio = circulatingSupply.mul(1e4).div(totalStakedTokens);\n', '        if (localinverseStakeRatio > 20 * 1e4) {\n', '            // staking rate <= 5%, APR 80%\n', '            return 8000;\n', '        } else {\n', '            return localinverseStakeRatio.div(25);\n', '        }\n', '    }\n', '\n', '    function rewardRateDelta() internal view returns (uint) {\n', '        return now.sub(lastRateUpdatedTime).mul(getCurrentAPR()).mul(1e6).div(ONEYEAR);\n', '    }\n', '\n', '    function updateGlobalRewardIndex() internal {\n', '        accumulatedRewardIndex = accumulatedRewardIndex.add(rewardRateDelta());\n', '        lastRateUpdatedTime = now;\n', '    }\n', '\n', '    function getNodeRewardsCore(Node storage _n, uint _indexRT) internal view returns(uint) {\n', '        if (!_n.running) return _n.accumulatedRewards;\n', '        return\n', '            _n.accumulatedRewards.add(\n', '                _n.selfStakedAmount.add(_n.totalOtherDelegatedAmount.mul(_n.rewardCut).div(100)).mul(\n', '                    _indexRT.sub(_n.accumulatedRewardIndex)\n', '                ).div(1e10)\n', '            );\n', '    }\n', '\n', '    function getDelegatorRewardsCore(Node storage _n, Delegation storage _d, uint _indexRT) internal view returns(uint) {\n', '        if (!_n.running) return _d.accumulatedRewards;\n', '        return\n', '            _d.accumulatedRewards.add(\n', '                _d.delegatedAmount.mul(100.sub(_n.rewardCut)).div(100).mul(\n', '                    _indexRT.sub(_d.accumulatedRewardIndex)\n', '                ).div(1e10)\n', '            );\n', '    }\n', '\n', '    function getNodeRewardTokens(address _nodeAddr) internal view returns(uint) {\n', '        return getNodeRewardsCore(nodes[_nodeAddr], accumulatedRewardIndex);\n', '    }\n', '\n', '    /// @dev returns realtime node staking rewards without any state change (specifically the global accumulatedRewardIndex)\n', '    function getNodeRewardTokensRT(address _nodeAddr) public view returns(uint) {\n', '        uint indexRT = accumulatedRewardIndex.add(rewardRateDelta());\n', '        return getNodeRewardsCore(nodes[_nodeAddr], indexRT);\n', '    }\n', '\n', '    function getDelegatorRewardTokens(address _delegator, address _nodeAddr) internal view returns(uint) {\n', '        return getDelegatorRewardsCore(nodes[_nodeAddr], delegators[_delegator][_nodeAddr], accumulatedRewardIndex);\n', '    }\n', '\n', "    /// @dev returns realtime delegator's staking rewards without any state change (specifically the global accumulatedRewardIndex)\n", '    function getDelegatorRewardTokensRT(address _delegator, address _nodeAddr) public view returns(uint) {\n', '        uint indexRT = accumulatedRewardIndex.add(rewardRateDelta());\n', '        return getDelegatorRewardsCore(nodes[_nodeAddr], delegators[_delegator][_nodeAddr], indexRT);\n', '    }\n', '}']