['pragma solidity ^ 0.4 .11;\n', '\n', '/**\n', ' * Overflow aware uint math functions.\n', ' *\n', ' * Inspired by https://github.com/MakerDAO/maker-otc/blob/master/contracts/simple_market.sol\n', ' */\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal returns(uint256) {\n', '        uint256 c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal returns(uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal returns(uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal returns(uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract Ownable {\n', '    address public owner;\n', '\n', '\n', '    /** \n', '     * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '     * account.\n', '     */\n', '    function Ownable() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '\n', '    modifier onlyOwner() {\n', '        if (msg.sender != owner) {\n', '            revert();\n', '        } else {\n', '            _;\n', '        }\n', '    }\n', '\n', '    function transferOwnership(address newOwner) onlyOwner {\n', '        if (newOwner != address(0)) {\n', '            owner = newOwner;\n', '        }\n', '    }\n', '\n', '\n', '}\n', '\n', '/**\n', ' * @title ERC20Basic\n', ' * @dev Simpler version of ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20Basic {\n', '    uint256 public totalSupply;\n', '\n', '    function balanceOf(address who) constant returns(uint256);\n', '\n', '    function transfer(address to, uint256 value);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title ERC20 interface\n', ' * @dev see https://github.com/ethereum/EIPs/issues/20\n', ' */\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender) constant returns(uint256);\n', '\n', '    function transferFrom(address from, address to, uint256 value);\n', '\n', '    function approve(address spender, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * @title Basic token\n', ' * @dev Basic version of StandardToken, with no allowances. \n', ' */\n', 'contract BasicToken is ERC20Basic {\n', '    using SafeMath\n', '    for uint256;\n', '    mapping(address => uint256) balances;\n', '\n', '\t/**\n', '\t  * @dev transfer token for a specified address\n', '\t  * @param _to The address to transfer to.\n', '\t  * @param _value The amount to be transferred.\n', '\t  */\n', '    function transfer(address _to, uint256 _value) {\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        Transfer(msg.sender, _to, _value);\n', '    }\n', '\t\n', '\t/**\n', '\t  * @dev Gets the balance of the specified address.\n', '\t  * @param _owner The address to query the the balance of. \n', '\t  * @return An uint256 representing the amount owned by the passed address.\n', '\t  */\n', '    function balanceOf(address _owner) constant returns(uint256 balance) {\n', '        return balances[_owner];\n', '    }\n', '\n', '}\n', '\n', 'contract StandardToken is ERC20, BasicToken {\n', '\n', '    mapping(address => mapping(address => uint256)) allowed;\n', '\t\n', '\t/**\n', '\t   * @dev Transfer tokens from one address to another\n', '\t   * @param _from address The address which you want to send tokens from\n', '\t   * @param _to address The address which you want to transfer to\n', '\t   * @param _value uint256 the amout of tokens to be transfered\n', '\t   */\n', '    function transferFrom(address _from, address _to, uint256 _value) {\n', '        var _allowance = allowed[_from][msg.sender];\n', '\n', '        // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met\n', '        // if (_value > _allowance) throw;\n', '\n', '        balances[_to] = balances[_to].add(_value);\n', '        balances[_from] = balances[_from].sub(_value);\n', '        allowed[_from][msg.sender] = _allowance.sub(_value);\n', '        Transfer(_from, _to, _value);\n', '    }\n', '\n', '\t  /**\n', '\t   * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '\t   * @param _spender The address which will spend the funds.\n', '\t   * @param _value The amount of tokens to be spent.\n', '\t   */\n', '    function approve(address _spender, uint256 _value) {\n', '\n', '        // To change the approve amount you first have to reduce the addresses`\n', '        //  allowance to zero by calling `approve(_spender, 0)` if it is not\n', '        //  already 0 to mitigate the race condition described here:\n', '        //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '        if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) revert();\n', '\n', '        allowed[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '    }\n', '\n', '\t/**\n', '\t   * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '\t   * @param _owner address The address which owns the funds.\n', '\t   * @param _spender address The address which will spend the funds.\n', '\t   * @return A uint256 specifing the amount of tokens still avaible for the spender.\n', '\t   */\n', '    function allowance(address _owner, address _spender) constant returns(uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '}\n', '\n', 'contract MintableToken is StandardToken, Ownable {\n', '    event Mint(address indexed to, uint256 amount);\n', '    event MintFinished();\n', '    event MintStarted();\n', '\n', '    bool public mintingFinished = true;\n', '    bool public goalReached = false;\n', '    uint public mintingStartTime = 0;\n', '    uint public maxMintingTime = 30 days;\n', '    uint public mintingGoal = 500 ether;\n', '\n', '     mapping(address => uint256) buyTransactions;\n', '    address public titsTokenAuthor = 0x189891d02445D87e70d515fD2159416f023B0087;\n', '\n', '\t/**\n', '\t   * @dev Fell fre to donate Author if You like what is presented here\n', '\t   */\n', '    function donateAuthor() payable {\n', '        titsTokenAuthor.transfer(msg.value);\n', '    }\n', '\n', '    bool public alreadyMintedOnce = false;\n', '\n', '    modifier mintingClosed() {\n', '        if (mintingFinished == false || alreadyMintedOnce == false) revert();\n', '        _;\n', '    }\n', '\n', '    modifier notMintedYet() {\n', '        if (alreadyMintedOnce == true) revert();\n', '        _;\n', '    }\n', '\n', '    \n', '\t/**\n', '\t   * @dev Premium for buying TITS at the begining of ICO \n', '\t   * @return bool True if no errors\n', '\t   */\n', '    function fastBuyBonus() private returns(uint) {\n', '        uint period = now - mintingStartTime;\n', '        if (period < 1 days) {\n', '            return 5000;\n', '        }\n', '        if (period < 2 days) {\n', '            return 4000;\n', '        }\n', '        if (period < 3 days) {\n', '            return 3000;\n', '        }\n', '        if (period < 7 days) {\n', '            return 2600;\n', '        }\n', '        if (period < 10 days) {\n', '            return 2400;\n', '        }\n', '        if (period < 12 days) {\n', '            return 2200;\n', '        }\n', '        if (period < 14 days) {\n', '            return 2000;\n', '        }\n', '        if (period < 17 days) {\n', '            return 1800;\n', '        }\n', '        if (period < 19 days) {\n', '            return 1600;\n', '        }\n', '        if (period < 21 days) {\n', '            return 1400;\n', '        }\n', '        if (period < 23 days) {\n', '            return 1200;\n', '        }\n', '        return 1000;\n', '    }\n', '\n', '\t/**\n', '\t   * @dev Allows to buy shares\n', '\t   * @return bool True if no errors\n', '\t   */\n', '    function buy() payable returns(bool) {\n', '        if (mintingFinished) {\n', '            revert();\n', '        }\n', '\n', '        uint _amount = 0;\n', '        _amount = msg.value * fastBuyBonus();\n', '        totalSupply = totalSupply.add(_amount);\n', '        balances[msg.sender] = balances[msg.sender].add(_amount);\n', '        balances[owner] = balances[owner].add(_amount / 85 * 15); //15% shares of owner\n', '\t\tbuyTransactions[msg.sender].add(msg.value);\n', '        return true;\n', '    }\n', '\n', '\t/**\n', '\t   * @dev Opens ICO (only owner)\n', '\t   * @return bool True if no errors\n', '\t   */\n', '    function startMinting() onlyOwner returns(bool) {\n', '        mintingStartTime = now;\n', '        if (alreadyMintedOnce) {\n', '            revert();\n', '        }\n', '        alreadyMintedOnce = true;\n', '        mintingFinished = false;\n', '        MintStarted();\n', '        return true;\n', '    }\n', '\n', '\t/**\n', '\t   * @dev Closes ICO - anyone can invoke if invoked to soon, takes no actions\n', '\t   * @return bool True if no errors\n', '\t   */\n', '    function finishMinting() returns(bool) {\n', '        if (mintingFinished == false) {\n', '            if (now - mintingStartTime > maxMintingTime) {\n', '                mintingFinished = true;\n', '                MintFinished();\n', '                goalReached = (this.balance > mintingGoal);\n', '                return true;\n', '            }\n', '        }\n', '        return false;\n', '    }\n', '\n', '\t/**\n', '\t   * @dev Function refunds contributors if ICO was unsuccesful \n', '\t   * @return bool True if conditions for refund are met false otherwise.\n', '\t   */\n', '    function refund() returns(bool) {\n', '        if (mintingFinished == true && goalReached == false && alreadyMintedOnce == true) {\n', '            balances[msg.sender] = 0;\n', '\t\t\ttotalSupply = totalSupply.sub(balances[msg.sender]);\n', '\t\t\tuint valueOfInvestment =  buyTransactions[msg.sender];\n', '            msg.sender.transfer(valueOfInvestment);\n', '\t\t\treturn true;\n', '        }\n', '\t\treturn false;\n', '    }\n', ' \n', ' \n', '\t/**\n', '\t   * @dev Allows to remove buggy contract before ICO launch\n', '\t   */\n', '    function destroyUselessContract() onlyOwner notMintedYet {\n', '        selfdestruct(owner);\n', '    }\n', '}\n', '\n', 'contract TitsToken is MintableToken {\n', '    string public name = "Truth In The Sourcecode";\n', '    string public symbol = "TITS";\n', '    uint public decimals = 18;\n', '    uint public voitingStartTime;\n', '    address public votedAddress;\n', '    uint public votedYes = 1;\n', '    uint public votedNo = 0;\n', '    event VoteOnTransfer(address indexed beneficiaryContract);\n', '    event RogisterToVoteOnTransfer(address indexed beneficiaryContract);\n', '    event VotingEnded(address indexed beneficiaryContract, bool result);\n', '\n', '    uint public constant VOTING_PREPARE_TIMESPAN = 7 days;\n', '    uint public constant VOTING_TIMESPAN =  7 days;\n', '    uint public failedVotingCount = 0;\n', '    bool public isVoting = false;\n', '    bool public isVotingPrepare = false;\n', '\n', '    address public beneficiaryContract = address(0);\n', '\n', '    mapping(address => uint256) votesAvailable;\n', '    address[] public voters;\n', '    uint votersCount = 0;\n', '\n', '\t/**\n', '\t   * @dev voting long enought to go to next phase \n', '\t   */\n', '    modifier votingLong() {\n', '        if (now - voitingStartTime < VOTING_TIMESPAN) revert();\n', '        _;\n', '    }\n', '\n', '\t/**\n', '\t   * @dev preparation for voting (application for voting) long enought to go to next phase \n', '\t   */\n', '    modifier votingPrepareLong() {\n', '        if (now - voitingStartTime < VOTING_PREPARE_TIMESPAN) revert();\n', '        _;\n', '    }\n', '\n', '\t/**\n', '\t   * @dev Voting started and in progress\n', '\t   */\n', '    modifier votingInProgress() {\n', '        if (isVoting == false) revert();\n', '        _;\n', '    }\n', '\n', '\t/**\n', '\t   * @dev Voting preparation started and in progress\n', '\t   */\n', '    modifier votingPrepareInProgress() {\n', '        if (isVotingPrepare == false) revert();\n', '        _;\n', '    }\n', '\n', '\t/**\n', '\t   * @dev Voters agreed on proposed contract and Ethereum is being send to that contract\n', '\t   */\n', '    function sendToBeneficiaryContract()  {\n', '        if (beneficiaryContract != address(0)) {\n', '            beneficiaryContract.transfer(this.balance);\n', '        } else {\n', '            revert();\n', '        }\n', '    }\n', '\t\t\n', '\t/**\n', '\t   * @dev can be called by anyone, if timespan withou accepted proposal long enought \n', '\t   * enables refund\n', '\t   */\n', '\tfunction registerVotingPrepareFailure() mintingClosed{\n', '\t\tif(now-mintingStartTime>(2+failedVotingCount)*maxMintingTime ){\n', '\t\t\tfailedVotingCount=failedVotingCount+1;\n', '            if (failedVotingCount == 10) {\n', '                goalReached = false;\n', '            }\n', '\t\t}\n', '\t}\n', '\n', '\t/**\n', '\t   * @dev opens preparation for new voting on proposed Lottery Contract address\n', '\t   */\n', '    function startVotingPrepare(address votedAddressArg) mintingClosed onlyOwner{\n', '        isVoting = false;\n', '        RogisterToVoteOnTransfer(votedAddressArg);\n', '        votedAddress = votedAddressArg;\n', '        voitingStartTime = now;\n', '        isVotingPrepare = true;\n', '        for (uint i = 0; i < voters.length; i++) {\n', '            delete voters[i];\n', '        }\n', '        delete voters;\n', '        votersCount = 0;\n', '    }\n', '\n', '\t/**\n', '\t   * @dev payable so attendance only of people who really care\n', '\t   * registers You as a voter;\n', '\t   */\n', '    function registerForVoting() payable votingPrepareInProgress {\n', '        if (msg.value >= 10 finney) {\n', '            voters.push(msg.sender);\n', '            votersCount = votersCount + 1;\n', '        }\n', '\t\telse{\n', '\t\t\trevert();\n', '\t\t}\n', '    }\n', '\n', '\t/**\n', '\t   * @dev opens voting on proposed Lottery Contract address\n', '\t   */\n', '    function startVoting() votingPrepareInProgress votingPrepareLong {\n', '        VoteOnTransfer(votedAddress);\n', '        for (uint i = 0; i < votersCount; i++) {\n', '            votesAvailable[voters[i]] = balanceOf(voters[i]);\n', '        }\n', '        isVoting = true;\n', '        voitingStartTime = now;\n', '        isVotingPrepare = false;\n', '        votersCount = 0;\n', '    }\n', '\n', '\t/**\n', '\t   * @dev closes voting on proposed Lottery Contract address\n', '\t   * checks if failed - if No votes is more common than yes increase failed voting count and if it reaches 10 \n', '\t   * reach of goal is failing and investors can withdraw their money\n', '\t   */\n', '    function closeVoring() votingInProgress votingLong {\n', '        VotingEnded(votedAddress, votedYes > votedNo);\n', '        isVoting = false;\n', '        isVotingPrepare = false;\n', '        if (votedYes > votedNo) {\n', '            beneficiaryContract = votedAddress;\n', '        } else {\n', '            failedVotingCount = failedVotingCount + 1;\n', '            if (failedVotingCount == 10) {\n', '                goalReached = false;\n', '            }\n', '        }\n', '    }\n', '\n', '\t/**\n', '\t   * @dev votes on contract proposal\n', '\t   * payable to ensure only serious voters will attend \n', '\t   */\n', '    function vote(bool isVoteYes) payable {\n', '\n', '        if (msg.value >= 10 finney) {\n', '            var votes = votesAvailable[msg.sender];\n', '            votesAvailable[msg.sender] = 0;\n', '            if (isVoteYes) {\n', '                votedYes.add(votes);\n', '            } else {\n', '                votedNo.add(votes);\n', '            }\n', '        }\n', '\t\telse{\n', '\t\t\trevert();\n', '\t\t}\n', '    }\n', '}']