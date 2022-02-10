['/*\n', '                    |   _|_)                             \n', '  __|  _ \\  _ \\  _` |  |   | __ \\   _` | __ \\   __|  _ \\ \n', '\\__ \\  __/  __/ (   |  __| | |   | (   | |   | (     __/ \n', '____/\\___|\\___|\\__,_| _|  _|_|  _|\\__,_|_|  _|\\___|\\___| \n', '* Home: https://superseed.cc\n', '* https://t.me/superseedgroup\n', '* https://twitter.com/superseedtoken\n', '* https://superseedtoken.medium.com\n', '* MIT License\n', '* ===========\n', '*\n', '* Copyright (c) 2020 Superseed\n', '* SPDX-License-Identifier: MIT\n', '* Permission is hereby granted, free of charge, to any person obtaining a copy\n', '* of this software and associated documentation files (the "Software"), to deal\n', '* in the Software without restriction, including without limitation the rights\n', '* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell\n', '* copies of the Software, and to permit persons to whom the Software is\n', '* furnished to do so, subject to the following conditions:\n', '*\n', '* The above copyright notice and this permission notice shall be included in all\n', '* copies or substantial portions of the Software.\n', '*\n', '* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR\n', '* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,\n', '* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE\n', '* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER\n', '* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,\n', '* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE\n', '*/\n', 'pragma solidity ^0.7.0;\n', '\n', 'interface IOwnershipTransferrable {\n', '  function transferOwnership(address owner) external;\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '}\n', '\n', 'abstract contract Ownable is IOwnershipTransferrable {\n', '  address private _owner;\n', '\n', '  constructor(address owner) {\n', '    _owner = owner;\n', '    emit OwnershipTransferred(address(0), _owner);\n', '  }\n', '\n', '  function owner() public view returns (address) {\n', '    return _owner;\n', '  }\n', '\n', '  modifier onlyOwner() {\n', '    require(_owner == msg.sender, "Ownable: caller is not the owner");\n', '    _;\n', '  }\n', '\n', '  function transferOwnership(address newOwner) override external onlyOwner {\n', '    require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '    emit OwnershipTransferred(_owner, newOwner);\n', '    _owner = newOwner;\n', '  }\n', '}\n', '\n', 'library SafeMath {\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    require(c >= a);\n', '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b <= a);\n', '    uint256 c = a - b;\n', '    return c;\n', '  }\n', '\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    if (a == 0) {\n', '      return 0;\n', '    }\n', '    uint256 c = a * b;\n', '    require(c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b > 0);\n', '    uint256 c = a / b;\n', '    return c;\n', '  }\n', '\n', '  function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    require(b != 0);\n', '    return a % b;\n', '  }\n', '}\n', '\n', 'contract Seed is Ownable {\n', '  using SafeMath for uint256;\n', '  uint256 private _totalSupply;\n', '  uint256 constant UINT256_MAX = ~uint256(0);\n', '  string private _name;\n', '  string private _symbol;\n', '  uint8 private _decimals;\n', '  \n', '  mapping(address => uint256) private _balances;\n', '  mapping(address => mapping(address => uint256)) private _allowances;\n', '\n', '  event Transfer(address indexed from, address indexed to, uint256 value);\n', '  event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '  constructor() Ownable(msg.sender) { \n', '    _name = "Seed";\n', '    _symbol = "SEED";\n', '    _decimals = 18;\n', '\t_totalSupply = 50000 * 1e18;\n', '\n', '    _balances[msg.sender] = _totalSupply;\n', '    emit Transfer(address(0), msg.sender, _totalSupply);\n', '  }\n', '\n', '  function totalSupply() external view returns (uint256) {\n', '    return _totalSupply;\n', '  }\n', '  \n', '  function name() external view returns (string memory) {\n', '    return _name;\n', '  }\n', '\n', '  function symbol() external view returns (string memory) {\n', '    return _symbol;\n', '  }\n', '\n', '  function decimals() external view returns (uint8) {\n', '    return _decimals;\n', '  }\n', '\n', '  function balanceOf(address account) external view returns (uint256) {\n', '    return _balances[account];\n', '  }\n', '\n', '  function allowance(address owner, address spender) external view returns (uint256) {\n', '    return _allowances[owner][spender];\n', '  }\n', '\n', '  function transfer(address recipient, uint256 amount) external returns (bool) {\n', '    _transfer(msg.sender, recipient, amount);\n', '    return true;\n', '  }\n', '\n', '  function approve(address spender, uint256 amount) external returns (bool) {\n', '    _approve(msg.sender, spender, amount);\n', '    return true;\n', '  }\n', '\n', '  function transferFrom(address sender, address recipient, uint256 amount) external returns (bool) {\n', '    _transfer(sender, recipient, amount);\n', '    if (_allowances[msg.sender][sender] != UINT256_MAX) {\n', '      _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));\n', '    }\n', '    return true;\n', '  }\n', '  \n', '  function _transfer(address sender, address recipient, uint256 amount) internal {\n', '    require(sender != address(0));\n', '    require(recipient != address(0));\n', '\n', '    _balances[sender] = _balances[sender].sub(amount);\n', '    _balances[recipient] = _balances[recipient].add(amount);\n', '    emit Transfer(sender, recipient, amount);\n', '  }\n', '  \n', '  function mint(address account, uint256 amount) external onlyOwner {\n', '    _totalSupply = _totalSupply.add(amount);\n', '    _balances[account] = _balances[account].add(amount);\n', '    emit Transfer(address(0), account, amount);\n', '  }  \n', '\n', '  function increaseAllowance(address spender, uint256 addedValue) external returns (bool) {\n', '    _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));\n', '    return true;\n', '  }\n', '\n', '  function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool) {\n', '    _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));\n', '    return true;\n', '  }\n', '\n', '  function _approve(address owner, address spender, uint256 amount) internal {\n', '    require(owner != address(0));\n', '    require(spender != address(0));\n', '\n', '    _allowances[owner][spender] = amount;\n', '    emit Approval(owner, spender, amount);\n', '  }\n', '\n', '  function burn(uint256 amount) external returns (bool) {\n', '    _balances[msg.sender] = _balances[msg.sender].sub(amount);\n', '    _totalSupply = _totalSupply.sub(amount);\n', '    emit Transfer(msg.sender, address(0), amount);\n', '    return true;\n', '  }\n', '}\n']
['/*\n', '                    |   _|_)                             \n', '  __|  _ \\  _ \\  _` |  |   | __ \\   _` | __ \\   __|  _ \\ \n', '\\__ \\  __/  __/ (   |  __| | |   | (   | |   | (     __/ \n', '____/\\___|\\___|\\__,_| _|  _|_|  _|\\__,_|_|  _|\\___|\\___| \n', '* Home: https://superseed.cc\n', '* https://t.me/superseedgroup\n', '* https://twitter.com/superseedtoken\n', '* https://superseedtoken.medium.com\n', '* MIT License\n', '* ===========\n', '*\n', '* Copyright (c) 2020 Superseed\n', '* SPDX-License-Identifier: MIT\n', '* Permission is hereby granted, free of charge, to any person obtaining a copy\n', '* of this software and associated documentation files (the "Software"), to deal\n', '* in the Software without restriction, including without limitation the rights\n', '* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell\n', '* copies of the Software, and to permit persons to whom the Software is\n', '* furnished to do so, subject to the following conditions:\n', '*\n', '* The above copyright notice and this permission notice shall be included in all\n', '* copies or substantial portions of the Software.\n', '*\n', '* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR\n', '* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,\n', '* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE\n', '* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER\n', '* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,\n', '* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE\n', '*/\n', 'pragma solidity ^0.7.0;\n', '\n', 'import "./Seed.sol";\n', '\n', 'abstract contract ReentrancyGuard {\n', '  bool private _entered;\n', '\n', '  modifier noReentrancy() {\n', '    require(!_entered);\n', '    _entered = true;\n', '    _;\n', '    _entered = false;\n', '  }\n', '}\n', '\n', 'interface ISeedStake is IOwnershipTransferrable {\n', '  event StakeIncreased(address indexed staker, uint256 amount);\n', '  event StakeDecreased(address indexed staker, uint256 amount);\n', '  event Rewards(address indexed staker, uint256 mintage, uint256 developerFund);\n', '  event MelodyAdded(address indexed melody);\n', '  event MelodyRemoved(address indexed melody);\n', '\n', '  function seed() external returns (address);\n', '  function totalStaked() external returns (uint256);\n', '  function staked(address staker) external returns (uint256);\n', '  function lastClaim(address staker) external returns (uint256);\n', '\n', '  function addMelody(address melody) external;\n', '  function removeMelody(address melody) external;\n', '  function upgrade(address owned, address upgraded) external;\n', '}\n', '\n', 'contract SeedDAO is ReentrancyGuard {\n', '  using SafeMath for uint256;\n', '  uint256 constant PROPOSAL_FEE = 10 * 1e18;\n', '\n', '  event NewProposal(uint64 indexed proposal);\n', '\n', '  event FundProposed(uint64 indexed proposal, address indexed destination, uint256 amount);\n', '  event MelodyAdditionProposed(uint64 indexed proposal, address melody);\n', '  event MelodyRemovalProposed(uint64 indexed proposal, address melody);\n', '  event StakeUpgradeProposed(uint64 indexed proposal, address newStake);\n', '  event DAOUpgradeProposed(uint64 indexed proposal, address newDAO);\n', '\n', '  event ProposalVoteAdded(uint64 indexed proposal, address indexed staker);\n', '  event ProposalVoteRemoved(uint64 indexed proposal, address indexed staker);\n', '\n', '  event ProposalPassed(uint64 indexed proposal);\n', '  event ProposalRemoved(uint64 indexed proposal);\n', '\n', '  enum ProposalType { Null, Fund, MelodyAddition, MelodyRemoval, StakeUpgrade, DAOUpgrade }\n', '  struct ProposalMetadata {\n', '    ProposalType pType;\n', '    // Allows the creator to withdraw the proposal\n', '    address creator;\n', '    // Used to mark proposals older than 30 days as invalid\n', '    uint256 submitted;\n', '    // Stakers who voted yes\n', '    mapping(address => bool) stakers;\n', '    // Whether or not the proposal is completed\n', '    // Stops it from being acted on multiple times\n', '    bool completed;\n', '  }\n', '\n', '  // The info string is intended for an URL to describe the proposal\n', '  struct FundProposal {\n', '    address destination;\n', '    uint256 amount;\n', '    string info;\n', '  }\n', '\n', '  struct MelodyAdditionProposal {\n', '    address melody;\n', '    string info;\n', '  }\n', '\n', '  struct MelodyRemovalProposal {\n', '    address melody;\n', '    string info;\n', '  }\n', '\n', '  struct StakeUpgradeProposal {\n', '    address newStake;\n', '    // List of addresses owned by the Stake contract\n', '    address[] owned;\n', '    string info;\n', '  }\n', '\n', '  struct DAOUpgradeProposal {\n', '    address newDAO;\n', '    string info;\n', '  }\n', '\n', '  mapping(uint64 => ProposalMetadata) public proposals;\n', '  mapping(uint64 => mapping(address => bool)) public used;\n', '  mapping(uint64 => FundProposal) public _fundProposals;\n', '  mapping(uint64 => MelodyAdditionProposal) public _melodyAdditionProposals;\n', '  mapping(uint64 => MelodyRemovalProposal) public _melodyRemovalProposals;\n', '  mapping(uint64 => StakeUpgradeProposal) public _stakeUpgradeProposals;\n', '  mapping(uint64 => DAOUpgradeProposal) public _daoUpgradeProposals;\n', '\n', '  // Address of the DAO we upgraded to\n', '  address _upgrade;\n', '  // ID to use for the next proposal\n', '  uint64 _nextProposalID;\n', '  ISeedStake private _stake;\n', '  Seed private _SEED;\n', '\n', '  // Check the proposal is valid\n', '  modifier pendingProposal(uint64 proposal) {\n', '    require(proposals[proposal].pType != ProposalType.Null);\n', '    require(!proposals[proposal].completed);\n', "    // Don't allow old proposals to suddenly be claimed\n", '    require(proposals[proposal].submitted + 30 days > block.timestamp);\n', '    _;\n', '  }\n', '\n', "  // Check this contract hasn't been replaced\n", '  modifier active() {\n', '    require(_upgrade == address(0));\n', '    _;\n', '  }\n', '\n', '  constructor(address stake) {\n', '    _stake = ISeedStake(stake);\n', '    _SEED = Seed(_stake.seed());\n', '  }\n', '\n', '  function _createNewProposal(ProposalType pType) internal active returns (uint64) {\n', "    // Make sure this isn't spam by transferring the proposal fee\n", '    require(_SEED.transferFrom(msg.sender, address(this), PROPOSAL_FEE));\n', '\n', '    // Increment the next proposal ID now\n', "    // Means we don't have to return a value we subtract one from later\n", '    _nextProposalID += 1;\n', '    emit NewProposal(_nextProposalID);\n', '\n', "    // Set up the proposal's metadata\n", '    ProposalMetadata storage meta = proposals[_nextProposalID];\n', '    meta.pType = pType;\n', '    meta.creator = msg.sender;\n', '    meta.submitted = block.timestamp;\n', "    // Automatically vote for the proposal's creator\n", '    meta.stakers[msg.sender] = true;\n', '    emit ProposalVoteAdded(_nextProposalID, msg.sender);\n', '\n', '    return _nextProposalID;\n', '  }\n', '  \n', '   function stake() external view returns (address) {\n', '    return address(_stake);\n', '  }\n', '  \n', '  function upgraded() external view returns (bool) {\n', '    return _upgrade != address(0);\n', '  }\n', '\n', '  function upgrade() external view returns (address) {\n', '    return _upgrade;\n', '  } \n', '\n', '  function proposeFund(address destination, uint256 amount, string calldata info) external returns (uint64) {\n', '    uint64 proposalID = _createNewProposal(ProposalType.Fund);\n', '    _fundProposals[proposalID] = FundProposal(destination, amount, info);\n', '    emit FundProposed(proposalID, destination, amount);\n', '    return proposalID;\n', '  }\n', '\n', '  function proposeMelodyAddition(address melody, string calldata info) external returns (uint64) {\n', '    uint64 proposalID = _createNewProposal(ProposalType.MelodyAddition);\n', '    _melodyAdditionProposals[proposalID] = MelodyAdditionProposal(melody, info);\n', '    emit MelodyAdditionProposed(proposalID, melody);\n', '    return proposalID;\n', '  }\n', '\n', '  function proposeMelodyRemoval(address melody, string calldata info) external returns (uint64) {\n', '    uint64 proposalID = _createNewProposal(ProposalType.MelodyRemoval);\n', '    _melodyRemovalProposals[proposalID] = MelodyRemovalProposal(melody, info);\n', '    emit MelodyRemovalProposed(proposalID, melody);\n', '    return proposalID;\n', '  }\n', '\n', '  function proposeStakeUpgrade(address newStake, address[] calldata owned, string calldata info) external returns (uint64) {\n', '    uint64 proposalID = _createNewProposal(ProposalType.StakeUpgrade);\n', '\n', '    // Ensure the SEED token was included as an owned contract\n', '    for (uint i = 0; i < owned.length; i++) {\n', '      if (owned[i] == address(_SEED)) {\n', '        break;\n', '      }\n', '      require(i != owned.length - 1);\n', '    }\n', '    _stakeUpgradeProposals[proposalID] = StakeUpgradeProposal(newStake, owned, info);\n', '    emit StakeUpgradeProposed(proposalID, newStake);\n', '    return proposalID;\n', '  }\n', '\n', '  function proposeDAOUpgrade(address newDAO, string calldata info) external returns (uint64) {\n', '    uint64 proposalID = _createNewProposal(ProposalType.DAOUpgrade);\n', '    _daoUpgradeProposals[proposalID] = DAOUpgradeProposal(newDAO, info);\n', '    emit DAOUpgradeProposed(proposalID, newDAO);\n', '    return proposalID;\n', '  }\n', '\n', '  function addVote(uint64 proposalID) external active pendingProposal(proposalID) {\n', '    proposals[proposalID].stakers[msg.sender] = true;\n', '    emit ProposalVoteAdded(proposalID, msg.sender);\n', '  }\n', '\n', '  function removeVote(uint64 proposalID) external active pendingProposal(proposalID) {\n', '    proposals[proposalID].stakers[msg.sender] = false;\n', '    emit ProposalVoteRemoved(proposalID, msg.sender);\n', '  }\n', '\n', '  // Send the SEED held by this contract to what it upgraded to\n', '  // Intended to enable a contract like the timelock, if transferred to this\n', "  // Without this, it'd be trapped here, forever\n", '  function forwardSEED() public {\n', '    require(_upgrade != address(0));\n', '    require(_SEED.transfer(_upgrade, _SEED.balanceOf(address(this))));\n', '  }\n', '\n', '  // Complete a proposal\n', "  // Takes in a list of stakers so this contract doesn't have to track them all in an array\n", '  // This would be extremely expensive as a stakers vote weight can drop to 0\n', '  // This selective process allows only counting meaningful votes\n', '  function completeProposal(uint64 proposalID, address[] calldata stakers) external active pendingProposal(proposalID) noReentrancy {\n', '    ProposalMetadata storage meta = proposals[proposalID];\n', '\n', '    uint256 requirement;\n', '    // Only require a majority vote for a funding request/to remove a melody\n', '    if ((meta.pType == ProposalType.Fund) || (meta.pType == ProposalType.MelodyRemoval)) {\n', '      requirement = _stake.totalStaked().div(2).add(1);\n', '\n', '    // Require >66% to add a new melody\n', '    // Adding an insecure or malicious melody will cause the staking pool to be drained\n', '    } else if (meta.pType == ProposalType.MelodyAddition) {\n', '      requirement = _stake.totalStaked().div(3).mul(2).add(1);\n', '\n', '    // Require >80% to upgrade the stake/DAO contract\n', '    // Upgrading to an insecure or malicious contract risks unlimited minting\n', '    } else if ((meta.pType == ProposalType.StakeUpgrade) || (meta.pType == ProposalType.DAOUpgrade)) {\n', '      requirement = _stake.totalStaked().div(5).mul(4).add(1);\n', '\n', '    // Panic in case the enum is expanded and not properly handled here\n', '    } else {\n', '      require(false);\n', '    }\n', '\n', "    // Make sure there's enough vote weight behind this proposal\n", '    uint256 votes = 0;\n', '    for (uint i = 0; i < stakers.length; i++) {\n', "      // Don't allow people to vote with flash loans\n", '      if (_stake.lastClaim(stakers[i]) == block.timestamp) {\n', '        continue;\n', '      }\n', '      require(meta.stakers[stakers[i]]);\n', '      require(!used[proposalID][stakers[i]]);\n', '      used[proposalID][stakers[i]] = true;\n', '      votes = votes.add(_stake.staked(stakers[i]));\n', '    }\n', '    require(votes >= requirement);\n', '    meta.completed = true;\n', '    emit ProposalPassed(proposalID);\n', '\n', '    if (meta.pType == ProposalType.Fund) {\n', '      FundProposal memory proposal = _fundProposals[proposalID];\n', '      require(_SEED.transfer(proposal.destination, proposal.amount));\n', '\n', '    } else if (meta.pType == ProposalType.MelodyAddition) {\n', '      _stake.addMelody(_melodyAdditionProposals[proposalID].melody);\n', '\n', '    } else if (meta.pType == ProposalType.MelodyRemoval) {\n', '      _stake.removeMelody(_melodyRemovalProposals[proposalID].melody);\n', '\n', '    } else if (meta.pType == ProposalType.StakeUpgrade) {\n', '      StakeUpgradeProposal memory proposal = _stakeUpgradeProposals[proposalID];\n', '      for (uint i = 0; i < proposal.owned.length; i++) {\n', '        _stake.upgrade(proposal.owned[i], proposal.newStake);\n', '      }\n', '\n', '      // Register the new staking contract as a melody so it can move the funds over\n', '      _stake.addMelody(address(proposal.newStake));\n', '\n', '      _stake = ISeedStake(proposal.newStake);\n', '\n', '    } else if (meta.pType == ProposalType.DAOUpgrade) {\n', '      _upgrade = _daoUpgradeProposals[proposalID].newDAO;\n', '      _stake.transferOwnership(_upgrade);\n', '      forwardSEED();\n', '\n', '    } else {\n', '      require(false);\n', '    }\n', '  }\n', '\n', '  // Voluntarily withdraw a proposal\n', '  function withdrawProposal(uint64 proposalID) external active pendingProposal(proposalID) {\n', '    require(proposals[proposalID].creator == msg.sender);\n', '    proposals[proposalID].completed = true;\n', '    emit ProposalRemoved(proposalID);\n', '  }\n', '}\n']
