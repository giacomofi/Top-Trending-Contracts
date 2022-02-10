['pragma solidity ^0.4.14;\n', '\n', 'contract BountyBG {\n', '\n', '    address public owner;\n', '\n', '    uint256 public bountyCount = 0;\n', '    uint256 public minBounty = 10 finney;\n', '    uint256 public bountyFee = 2 finney;\n', '    uint256 public bountyFeeCount = 0;\n', '    uint256 public bountyBeneficiariesCount = 2;\n', '    uint256 public bountyDuration = 30 hours;\n', '\n', '    mapping(uint256 => Bounty) bountyAt;\n', '\n', '    event BountyStatus(string _msg, uint256 _id, address _from, uint256 _amount);\n', '    event RewardStatus(string _msg, uint256 _id, address _to, uint256 _amount);\n', '    event ErrorStatus(string _msg, uint256 _id, address _to, uint256 _amount);\n', '\n', '    struct Bounty {\n', '        uint256 id;\n', '        address owner;\n', '        uint256 bounty;\n', '        uint256 remainingBounty;\n', '        uint256 startTime;\n', '        uint256 endTime;\n', '        bool ended;\n', '        bool retracted;\n', '    }\n', '\n', '    function BountyBG() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    // BLOCKGEEKS ACTIONS\n', '\n', '    function withdrawFee(uint256 _amount) external onlyOwner {\n', '        require(_amount <= bountyFeeCount);\n', '        bountyFeeCount -= _amount;\n', '        owner.transfer(_amount);\n', '    }\n', '\n', '    function setBountyDuration(uint256 _bountyDuration) external onlyOwner {\n', '        bountyDuration = _bountyDuration;\n', '    }\n', '\n', '    function setMinBounty(uint256 _minBounty) external onlyOwner {\n', '        minBounty = _minBounty;\n', '    }\n', '\n', '    function setBountyBeneficiariesCount(uint256 _bountyBeneficiariesCount) external onlyOwner {\n', '        bountyBeneficiariesCount = _bountyBeneficiariesCount;\n', '    }\n', '\n', '    function rewardUsers(uint256 _bountyId, address[] _users, uint256[] _rewards) external onlyOwner {\n', '        Bounty storage bounty = bountyAt[_bountyId];\n', '        require(\n', '            !bounty.ended &&\n', '            !bounty.retracted &&\n', '            bounty.startTime + bountyDuration > block.timestamp &&\n', '            _users.length > 0 &&\n', '            _users.length <= bountyBeneficiariesCount &&\n', '            _users.length == _rewards.length\n', '        );\n', '\n', '\n', '\n', '\n', '\n', '        bounty.ended = true;\n', '        bounty.endTime = block.timestamp;\n', '        uint256 currentRewards = 0;\n', '        for (uint8 i = 0; i < _rewards.length; i++) {\n', '            currentRewards += _rewards[i];\n', '        }\n', '\n', '\n', '\n', '\n', '\n', '        require(bounty.bounty >= currentRewards);\n', '\n', '        for (i = 0; i < _users.length; i++) {\n', '            _users[i].transfer(_rewards[i]);\n', '            RewardStatus("Reward sent", bounty.id, _users[i], _rewards[i]);\n', '            /* if (_users[i].send(_rewards[i])) {\n', '                bounty.remainingBounty -= _rewards[i];\n', '                RewardStatus(&#39;Reward sent&#39;, bounty.id, _users[i], _rewards[i]);\n', '            } else {\n', '                ErrorStatus(&#39;Error in reward&#39;, bounty.id, _users[i], _rewards[i]);\n', '            } */\n', '        }\n', '    }\n', '\n', '    function rewardUser(uint256 _bountyId, address _user, uint256 _reward) external onlyOwner {\n', '        Bounty storage bounty = bountyAt[_bountyId];\n', '        require(bounty.remainingBounty >= _reward);\n', '        bounty.remainingBounty -= _reward;\n', '\n', '        bounty.ended = true;\n', '        bounty.endTime = block.timestamp;\n', '        \n', '        _user.transfer(_reward);\n', '        RewardStatus(&#39;Reward sent&#39;, bounty.id, _user, _reward);\n', '    }\n', '\n', '    // USER ACTIONS TRIGGERED BY METAMASK\n', '\n', '    function createBounty(uint256 _bountyId) external payable {\n', '        require(\n', '            msg.value >= minBounty + bountyFee\n', '        );\n', '        Bounty storage bounty = bountyAt[_bountyId];\n', '        require(bounty.id == 0);\n', '        bountyCount++;\n', '        bounty.id = _bountyId;\n', '        bounty.bounty = msg.value - bountyFee;\n', '        bounty.remainingBounty = bounty.bounty;\n', '        bountyFeeCount += bountyFee;\n', '        bounty.startTime = block.timestamp;\n', '        bounty.owner = msg.sender;\n', '        BountyStatus(&#39;Bounty submitted&#39;, bounty.id, msg.sender, msg.value);\n', '    }\n', '\n', '    function cancelBounty(uint256 _bountyId) external {\n', '        Bounty storage bounty = bountyAt[_bountyId];\n', '        require(\n', '            msg.sender == bounty.owner &&\n', '            !bounty.ended &&\n', '            !bounty.retracted &&\n', '            bounty.owner == msg.sender &&\n', '            bounty.startTime + bountyDuration < block.timestamp\n', '        );\n', '        bounty.ended = true;\n', '        bounty.retracted = true;\n', '        bounty.owner.transfer(bounty.bounty);\n', '        BountyStatus(&#39;Bounty was canceled&#39;, bounty.id, msg.sender, bounty.bounty);\n', '    }\n', '\n', '\n', '    // CUSTOM GETTERS\n', '\n', '    function getBalance() external view returns (uint256) {\n', '        return this.balance;\n', '    }\n', '\n', '    function getBounty(uint256 _bountyId) external view\n', '    returns (uint256, address, uint256, uint256, uint256, uint256, bool, bool) {\n', '        Bounty memory bounty = bountyAt[_bountyId];\n', '        return (\n', '            bounty.id,\n', '            bounty.owner,\n', '            bounty.bounty,\n', '            bounty.remainingBounty,\n', '            bounty.startTime,\n', '            bounty.endTime,\n', '            bounty.ended,\n', '            bounty.retracted\n', '        );\n', '    }\n', '\n', '}']
['pragma solidity ^0.4.14;\n', '\n', 'contract BountyBG {\n', '\n', '    address public owner;\n', '\n', '    uint256 public bountyCount = 0;\n', '    uint256 public minBounty = 10 finney;\n', '    uint256 public bountyFee = 2 finney;\n', '    uint256 public bountyFeeCount = 0;\n', '    uint256 public bountyBeneficiariesCount = 2;\n', '    uint256 public bountyDuration = 30 hours;\n', '\n', '    mapping(uint256 => Bounty) bountyAt;\n', '\n', '    event BountyStatus(string _msg, uint256 _id, address _from, uint256 _amount);\n', '    event RewardStatus(string _msg, uint256 _id, address _to, uint256 _amount);\n', '    event ErrorStatus(string _msg, uint256 _id, address _to, uint256 _amount);\n', '\n', '    struct Bounty {\n', '        uint256 id;\n', '        address owner;\n', '        uint256 bounty;\n', '        uint256 remainingBounty;\n', '        uint256 startTime;\n', '        uint256 endTime;\n', '        bool ended;\n', '        bool retracted;\n', '    }\n', '\n', '    function BountyBG() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    // BLOCKGEEKS ACTIONS\n', '\n', '    function withdrawFee(uint256 _amount) external onlyOwner {\n', '        require(_amount <= bountyFeeCount);\n', '        bountyFeeCount -= _amount;\n', '        owner.transfer(_amount);\n', '    }\n', '\n', '    function setBountyDuration(uint256 _bountyDuration) external onlyOwner {\n', '        bountyDuration = _bountyDuration;\n', '    }\n', '\n', '    function setMinBounty(uint256 _minBounty) external onlyOwner {\n', '        minBounty = _minBounty;\n', '    }\n', '\n', '    function setBountyBeneficiariesCount(uint256 _bountyBeneficiariesCount) external onlyOwner {\n', '        bountyBeneficiariesCount = _bountyBeneficiariesCount;\n', '    }\n', '\n', '    function rewardUsers(uint256 _bountyId, address[] _users, uint256[] _rewards) external onlyOwner {\n', '        Bounty storage bounty = bountyAt[_bountyId];\n', '        require(\n', '            !bounty.ended &&\n', '            !bounty.retracted &&\n', '            bounty.startTime + bountyDuration > block.timestamp &&\n', '            _users.length > 0 &&\n', '            _users.length <= bountyBeneficiariesCount &&\n', '            _users.length == _rewards.length\n', '        );\n', '\n', '\n', '\n', '\n', '\n', '        bounty.ended = true;\n', '        bounty.endTime = block.timestamp;\n', '        uint256 currentRewards = 0;\n', '        for (uint8 i = 0; i < _rewards.length; i++) {\n', '            currentRewards += _rewards[i];\n', '        }\n', '\n', '\n', '\n', '\n', '\n', '        require(bounty.bounty >= currentRewards);\n', '\n', '        for (i = 0; i < _users.length; i++) {\n', '            _users[i].transfer(_rewards[i]);\n', '            RewardStatus("Reward sent", bounty.id, _users[i], _rewards[i]);\n', '            /* if (_users[i].send(_rewards[i])) {\n', '                bounty.remainingBounty -= _rewards[i];\n', "                RewardStatus('Reward sent', bounty.id, _users[i], _rewards[i]);\n", '            } else {\n', "                ErrorStatus('Error in reward', bounty.id, _users[i], _rewards[i]);\n", '            } */\n', '        }\n', '    }\n', '\n', '    function rewardUser(uint256 _bountyId, address _user, uint256 _reward) external onlyOwner {\n', '        Bounty storage bounty = bountyAt[_bountyId];\n', '        require(bounty.remainingBounty >= _reward);\n', '        bounty.remainingBounty -= _reward;\n', '\n', '        bounty.ended = true;\n', '        bounty.endTime = block.timestamp;\n', '        \n', '        _user.transfer(_reward);\n', "        RewardStatus('Reward sent', bounty.id, _user, _reward);\n", '    }\n', '\n', '    // USER ACTIONS TRIGGERED BY METAMASK\n', '\n', '    function createBounty(uint256 _bountyId) external payable {\n', '        require(\n', '            msg.value >= minBounty + bountyFee\n', '        );\n', '        Bounty storage bounty = bountyAt[_bountyId];\n', '        require(bounty.id == 0);\n', '        bountyCount++;\n', '        bounty.id = _bountyId;\n', '        bounty.bounty = msg.value - bountyFee;\n', '        bounty.remainingBounty = bounty.bounty;\n', '        bountyFeeCount += bountyFee;\n', '        bounty.startTime = block.timestamp;\n', '        bounty.owner = msg.sender;\n', "        BountyStatus('Bounty submitted', bounty.id, msg.sender, msg.value);\n", '    }\n', '\n', '    function cancelBounty(uint256 _bountyId) external {\n', '        Bounty storage bounty = bountyAt[_bountyId];\n', '        require(\n', '            msg.sender == bounty.owner &&\n', '            !bounty.ended &&\n', '            !bounty.retracted &&\n', '            bounty.owner == msg.sender &&\n', '            bounty.startTime + bountyDuration < block.timestamp\n', '        );\n', '        bounty.ended = true;\n', '        bounty.retracted = true;\n', '        bounty.owner.transfer(bounty.bounty);\n', "        BountyStatus('Bounty was canceled', bounty.id, msg.sender, bounty.bounty);\n", '    }\n', '\n', '\n', '    // CUSTOM GETTERS\n', '\n', '    function getBalance() external view returns (uint256) {\n', '        return this.balance;\n', '    }\n', '\n', '    function getBounty(uint256 _bountyId) external view\n', '    returns (uint256, address, uint256, uint256, uint256, uint256, bool, bool) {\n', '        Bounty memory bounty = bountyAt[_bountyId];\n', '        return (\n', '            bounty.id,\n', '            bounty.owner,\n', '            bounty.bounty,\n', '            bounty.remainingBounty,\n', '            bounty.startTime,\n', '            bounty.endTime,\n', '            bounty.ended,\n', '            bounty.retracted\n', '        );\n', '    }\n', '\n', '}']
