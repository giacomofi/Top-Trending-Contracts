['pragma solidity ^0.4.24;\n', '\n', '/// @title DigixDAO&#39;s 2nd Carbon Voting contracts\n', '/// @author Digix Holdings\n', '\n', '/// @notice NumberCarbonVoting contract, generalized carbon voting contract\n', 'contract NumberCarbonVoting {\n', '    uint256 public start;\n', '    uint256 public end;\n', '    struct VoteItem {\n', '        bytes32 title;\n', '        uint256 minValue;\n', '        uint256 maxValue;\n', '        mapping (address => uint256) votes;\n', '    }\n', '\n', '    mapping(uint256 => VoteItem) public voteItems;\n', '    uint256 public itemCount;\n', '\n', '    mapping(address => bool) public voted;\n', '    address[] public voters;\n', '\n', '    constructor (\n', '        uint256 _itemCount,\n', '        bytes32[] _titles,\n', '        uint256[] _minValues,\n', '        uint256[] _maxValues,\n', '        uint256 _start,\n', '        uint256 _end\n', '    )\n', '        public\n', '    {\n', '        itemCount = _itemCount;\n', '        for (uint256 i=0;i<itemCount;i++) {\n', '            voteItems[i].title = _titles[i];\n', '            voteItems[i].minValue = _minValues[i];\n', '            voteItems[i].maxValue = _maxValues[i];\n', '        }\n', '        start = _start;\n', '        end = _end;\n', '    }\n', '\n', '    function vote(uint256[] _votes) public {\n', '        require(_votes.length == itemCount);\n', '        require(now >= start && now < end);\n', '\n', '        address voter = msg.sender;\n', '        if (!voted[voter]) {\n', '            voted[voter] = true;\n', '            voters.push(voter);\n', '        }\n', '\n', '        for (uint256 i=0;i<itemCount;i++) {\n', '            require(_votes[i] >= voteItems[i].minValue && _votes[i] <= voteItems[i].maxValue);\n', '            voteItems[i].votes[voter] = _votes[i];\n', '        }\n', '    }\n', '\n', '    function getAllVoters() public view\n', '        returns (address[] _voters)\n', '    {\n', '        _voters = voters;\n', '    }\n', '\n', '    function getVotesForItem(uint256 _itemIndex) public view\n', '        returns (address[] _voters, uint256[] _votes)\n', '    {\n', '        return getVotesForItemFromVoterIndex(_itemIndex, 0, voters.length);\n', '    }\n', '\n', '\n', '    /// @dev get votes for a subset of _count voters, from _voterIndex\n', '    function getVotesForItemFromVoterIndex(uint256 _itemIndex, uint256 _voterIndex, uint256 _count) public view\n', '        returns (address[] _voters, uint256[] _votes)\n', '    {\n', '        require(_itemIndex < itemCount);\n', '        require(_voterIndex < voters.length);\n', '\n', '        _count = min(voters.length - _voterIndex, _count);\n', '        _voters = new address[](_count);\n', '        _votes = new uint256[](_count);\n', '        for (uint256 i=0;i<_count;i++) {\n', '            _voters[i] = voters[_voterIndex + i];\n', '            _votes[i] = voteItems[_itemIndex].votes[_voters[i]];\n', '        }\n', '    }\n', '\n', '    function min(uint256 _a, uint256 _b) returns (uint256 _min) {\n', '        _min = _a;\n', '        if (_b < _a) {\n', '            _min = _b;\n', '        }\n', '    }\n', '\n', '    function getVoteItemDetails(uint256 _itemIndex) public view\n', '        returns (bytes32 _title, uint256 _minValue, uint256 _maxValue)\n', '    {\n', '        _title = voteItems[_itemIndex].title;\n', '        _minValue = voteItems[_itemIndex].minValue;\n', '        _maxValue = voteItems[_itemIndex].maxValue;\n', '    }\n', '\n', '    function getUserVote(address _voter) public view\n', '        returns (uint256[] _votes, bool _voted)\n', '    {\n', '        _voted = voted[_voter];\n', '        _votes = new uint256[](itemCount);\n', '        for (uint256 i=0;i<itemCount;i++) {\n', '            _votes[i] = voteItems[i].votes[_voter];\n', '        }\n', '    }\n', '}\n', '\n', '/// @notice the actual carbon voting contract, specific to DigixDAO&#39;s 2nd carbon voting: DigixDAO&#39;s first proposal\n', 'contract DigixDaoFirstProposal is NumberCarbonVoting {\n', '    constructor (\n', '        uint256 _itemCount,\n', '        bytes32[] _titles,\n', '        uint256[] _minValues,\n', '        uint256[] _maxValues,\n', '        uint256 _start,\n', '        uint256 _end\n', '    ) public NumberCarbonVoting(\n', '        _itemCount,\n', '        _titles,\n', '        _minValues,\n', '        _maxValues,\n', '        _start,\n', '        _end\n', '    ) {\n', '    }\n', '}']
['pragma solidity ^0.4.24;\n', '\n', "/// @title DigixDAO's 2nd Carbon Voting contracts\n", '/// @author Digix Holdings\n', '\n', '/// @notice NumberCarbonVoting contract, generalized carbon voting contract\n', 'contract NumberCarbonVoting {\n', '    uint256 public start;\n', '    uint256 public end;\n', '    struct VoteItem {\n', '        bytes32 title;\n', '        uint256 minValue;\n', '        uint256 maxValue;\n', '        mapping (address => uint256) votes;\n', '    }\n', '\n', '    mapping(uint256 => VoteItem) public voteItems;\n', '    uint256 public itemCount;\n', '\n', '    mapping(address => bool) public voted;\n', '    address[] public voters;\n', '\n', '    constructor (\n', '        uint256 _itemCount,\n', '        bytes32[] _titles,\n', '        uint256[] _minValues,\n', '        uint256[] _maxValues,\n', '        uint256 _start,\n', '        uint256 _end\n', '    )\n', '        public\n', '    {\n', '        itemCount = _itemCount;\n', '        for (uint256 i=0;i<itemCount;i++) {\n', '            voteItems[i].title = _titles[i];\n', '            voteItems[i].minValue = _minValues[i];\n', '            voteItems[i].maxValue = _maxValues[i];\n', '        }\n', '        start = _start;\n', '        end = _end;\n', '    }\n', '\n', '    function vote(uint256[] _votes) public {\n', '        require(_votes.length == itemCount);\n', '        require(now >= start && now < end);\n', '\n', '        address voter = msg.sender;\n', '        if (!voted[voter]) {\n', '            voted[voter] = true;\n', '            voters.push(voter);\n', '        }\n', '\n', '        for (uint256 i=0;i<itemCount;i++) {\n', '            require(_votes[i] >= voteItems[i].minValue && _votes[i] <= voteItems[i].maxValue);\n', '            voteItems[i].votes[voter] = _votes[i];\n', '        }\n', '    }\n', '\n', '    function getAllVoters() public view\n', '        returns (address[] _voters)\n', '    {\n', '        _voters = voters;\n', '    }\n', '\n', '    function getVotesForItem(uint256 _itemIndex) public view\n', '        returns (address[] _voters, uint256[] _votes)\n', '    {\n', '        return getVotesForItemFromVoterIndex(_itemIndex, 0, voters.length);\n', '    }\n', '\n', '\n', '    /// @dev get votes for a subset of _count voters, from _voterIndex\n', '    function getVotesForItemFromVoterIndex(uint256 _itemIndex, uint256 _voterIndex, uint256 _count) public view\n', '        returns (address[] _voters, uint256[] _votes)\n', '    {\n', '        require(_itemIndex < itemCount);\n', '        require(_voterIndex < voters.length);\n', '\n', '        _count = min(voters.length - _voterIndex, _count);\n', '        _voters = new address[](_count);\n', '        _votes = new uint256[](_count);\n', '        for (uint256 i=0;i<_count;i++) {\n', '            _voters[i] = voters[_voterIndex + i];\n', '            _votes[i] = voteItems[_itemIndex].votes[_voters[i]];\n', '        }\n', '    }\n', '\n', '    function min(uint256 _a, uint256 _b) returns (uint256 _min) {\n', '        _min = _a;\n', '        if (_b < _a) {\n', '            _min = _b;\n', '        }\n', '    }\n', '\n', '    function getVoteItemDetails(uint256 _itemIndex) public view\n', '        returns (bytes32 _title, uint256 _minValue, uint256 _maxValue)\n', '    {\n', '        _title = voteItems[_itemIndex].title;\n', '        _minValue = voteItems[_itemIndex].minValue;\n', '        _maxValue = voteItems[_itemIndex].maxValue;\n', '    }\n', '\n', '    function getUserVote(address _voter) public view\n', '        returns (uint256[] _votes, bool _voted)\n', '    {\n', '        _voted = voted[_voter];\n', '        _votes = new uint256[](itemCount);\n', '        for (uint256 i=0;i<itemCount;i++) {\n', '            _votes[i] = voteItems[i].votes[_voter];\n', '        }\n', '    }\n', '}\n', '\n', "/// @notice the actual carbon voting contract, specific to DigixDAO's 2nd carbon voting: DigixDAO's first proposal\n", 'contract DigixDaoFirstProposal is NumberCarbonVoting {\n', '    constructor (\n', '        uint256 _itemCount,\n', '        bytes32[] _titles,\n', '        uint256[] _minValues,\n', '        uint256[] _maxValues,\n', '        uint256 _start,\n', '        uint256 _end\n', '    ) public NumberCarbonVoting(\n', '        _itemCount,\n', '        _titles,\n', '        _minValues,\n', '        _maxValues,\n', '        _start,\n', '        _end\n', '    ) {\n', '    }\n', '}']
