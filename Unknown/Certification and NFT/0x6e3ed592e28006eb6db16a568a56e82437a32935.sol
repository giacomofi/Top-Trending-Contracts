['pragma solidity ^0.4.8;\n', '\n', '/// @title Oracle contract where m of n predetermined voters determine a value\n', 'contract FederatedOracleBytes8 {\n', '    struct Voter {\n', '        bool isVoter;\n', '        bool hasVoted;\n', '    }\n', '\n', '    event VoterAdded(address account);\n', '    event VoteSubmitted(address account, bytes8 value);\n', '    event ValueFinalized(bytes8 value);\n', '\n', '    mapping(address => Voter) public voters;\n', '    mapping(bytes8 => uint8) public votes;\n', '\n', '    uint8 public m;\n', '    uint8 public n;\n', '    bytes8 public finalValue;\n', '\n', '    uint8 private voterCount;\n', '    address private creator;\n', '\n', '    function FederatedOracleBytes8(uint8 m_, uint8 n_) {\n', '        creator = msg.sender;\n', '        m = m_;\n', '        n = n_;\n', '    }\n', '\n', '    function addVoter(address account) {\n', '        if (msg.sender != creator) {\n', '            throw;\n', '        }\n', '        if (voterCount == n) {\n', '            throw;\n', '        }\n', '\n', '        var voter = voters[account];\n', '        if (voter.isVoter) {\n', '            throw;\n', '        }\n', '\n', '        voter.isVoter = true;\n', '        voterCount++;\n', '        VoterAdded(account);\n', '    }\n', '\n', '    function submitValue(bytes8 value) {\n', '        var voter = voters[msg.sender];\n', '        if (!voter.isVoter) {\n', '            throw;\n', '        }\n', '        if (voter.hasVoted) {\n', '            throw;\n', '        }\n', '\n', '        voter.hasVoted = true;\n', '        votes[value]++;\n', '        VoteSubmitted(msg.sender, value);\n', '\n', '        if (votes[value] == m) {\n', '            finalValue = value;\n', '            ValueFinalized(value);\n', '        }\n', '    }\n', '}\n', '\n', '// This library can be used to score byte brackets. Byte brackets are a succinct encoding of a\n', '// 64 team bracket into an 8-byte array. The tournament results are encoded in the same format and\n', '// compared against the bracket picks. To reduce the computation time of scoring a bracket, a 64-bit\n', '// value called the "scoring mask" is first computed once for a particular result set and used to\n', '// score all brackets.\n', '//\n', '// Algorithm description: https://drive.google.com/file/d/0BxHbbgrucCx2N1MxcnA1ZE1WQW8/view\n', '// Reference implementation: https://gist.github.com/pursuingpareto/b15f1197d96b1a2bbc48\n', 'library ByteBracket {\n', '    function getBracketScore(bytes8 bracket, bytes8 results, uint64 filter)\n', '        constant\n', '        returns (uint8 points)\n', '    {\n', '        uint8 roundNum = 0;\n', '        uint8 numGames = 32;\n', '        uint64 blacklist = (uint64(1) << numGames) - 1;\n', '        uint64 overlap = uint64(~(bracket ^ results));\n', '\n', '        while (numGames > 0) {\n', '            uint64 scores = overlap & blacklist;\n', '            points += popcount(scores) << roundNum;\n', '            blacklist = pairwiseOr(scores & filter);\n', '            overlap >>= numGames;\n', '            filter >>= numGames;\n', '            numGames /= 2;\n', '            roundNum++;\n', '        }\n', '    }\n', '\n', '    function getScoringMask(bytes8 results) constant returns (uint64 mask) {\n', '        // Filter for the second most significant bit since MSB is ignored.\n', '        bytes8 bitSelector = 1 << 62;\n', '        for (uint i = 0; i < 31; i++) {\n', '            mask <<= 2;\n', '            if (results & bitSelector != 0) {\n', '                mask |= 1;\n', '            } else {\n', '                mask |= 2;\n', '            }\n', '            results <<= 1;\n', '        }\n', '    }\n', '\n', '    // Returns a bitstring of half the length by taking bits two at a time and ORing them.\n', '    //\n', '    // Separates the even and odd bits by repeatedly\n', '    // shuffling smaller segments of a bitstring.\n', '    function pairwiseOr(uint64 bits) internal returns (uint64) {\n', '        uint64 tmp;\n', '        tmp = (bits ^ (bits >> 1)) & 0x22222222;\n', '        bits ^= (tmp ^ (tmp << 1));\n', '        tmp = (bits ^ (bits >> 2)) & 0x0c0c0c0c;\n', '        bits ^= (tmp ^ (tmp << 2));\n', '        tmp = (bits ^ (bits >> 4)) & 0x00f000f0;\n', '        bits ^= (tmp ^ (tmp << 4));\n', '        tmp = (bits ^ (bits >> 8)) & 0x0000ff00;\n', '        bits ^= (tmp ^ (tmp << 8));\n', '        uint64 evens = bits >> 16;\n', '        uint64 odds = bits % 0x10000;\n', '        return evens | odds;\n', '    }\n', '\n', '    // Counts the number of 1s in a bitstring.\n', '    function popcount(uint64 bits) internal returns (uint8) {\n', '        bits -= (bits >> 1) & 0x5555555555555555;\n', '        bits = (bits & 0x3333333333333333) + ((bits >> 2) & 0x3333333333333333);\n', '        bits = (bits + (bits >> 4)) & 0x0f0f0f0f0f0f0f0f;\n', '        return uint8(((bits * 0x0101010101010101) & 0xffffffffffffffff) >> 56);\n', '    }\n', '}\n', '\n', '/**\n', ' * @title March Madness bracket pool smart contract\n', ' *\n', ' * The contract has four phases: submission, tournament, scoring, then the contest is over. During\n', ' * the submission phase, entrants submit a cryptographic commitment to their bracket picks. Each\n', ' * address may only make one submission. Entrants may reveal their brackets at any time after making\n', ' * the commitment. Once the tournament starts, no further submissions are allowed. When the\n', ' * tournament ends, the results are submitted by the oracles and the scoring period begins. During\n', ' * the scoring period, entrants may reveal their bracket picks and score their brackets. The highest\n', ' * scoring bracket revealed is recorded. After the scoring period ends, all entrants with a highest\n', ' * scoring bracket split the pot and may withdraw their winnings.\n', ' *\n', ' * In the event that the oracles do not submit results or fail to reach consensus after a certain\n', ' * amount of time, entry fees will be returned to entrants.\n', ' */\n', 'contract MarchMadness {\n', '    struct Submission {\n', '        bytes32 commitment;\n', '        bytes8 bracket;\n', '        uint8 score;\n', '        bool collectedWinnings;\n', '        bool collectedEntryFee;\n', '    }\n', '\n', '    event SubmissionAccepted(address account);\n', '    event NewWinner(address winner, uint8 score);\n', '    event TournamentOver();\n', '\n', '    FederatedOracleBytes8 resultsOracle;\n', '\n', '\tmapping(address => Submission) submissions;\n', '\n', '    // Amount that winners will collect\n', '    uint public winnings;\n', '\n', '    // Number of submissions with a winning score\n', '    uint public numWinners;\n', '\n', '    // Data derived from results used by bracket scoring algorithm\n', '    uint64 private scoringMask;\n', '\n', '    // Fee in wei required to enter a bracket\n', '    uint public entryFee;\n', '\n', '    // Duration in seconds of the scoring phase\n', '    uint public scoringDuration;\n', '\n', '    // Timestamp of the start of the tournament phase\n', '    uint public tournamentStartTime;\n', '\n', '    // In case the oracles fail to submit the results or reach consensus, the amount of time after\n', '    // the tournament has started after which to return entry fees to users.\n', '    uint public noContestTime;\n', '\n', '    // Timestamp of the end of the scoring phase\n', '    uint public contestOverTime;\n', '\n', '    // Byte bracket representation of the tournament results\n', '    bytes8 public results;\n', '\n', '    // The highest score of a bracket scored so far\n', '    uint8 public winningScore;\n', '\n', '    // The maximum allowed number of submissions\n', '    uint32 public maxSubmissions;\n', '\n', '    // The number of brackets submitted so far\n', '    uint32 public numSubmissions;\n', '\n', '    // IPFS hash of JSON file containing tournament information (eg. teams, regions, etc)\n', '    string public tournamentDataIPFSHash;\n', '\n', '\tfunction MarchMadness(\n', '        uint entryFee_,\n', '        uint tournamentStartTime_,\n', '        uint noContestTime_,\n', '        uint scoringDuration_,\n', '        uint32 maxSubmissions_,\n', '        string tournamentDataIPFSHash_,\n', '        address oracleAddress\n', '    ) {\n', '\t\tentryFee = entryFee_;\n', '        tournamentStartTime = tournamentStartTime_;\n', '        scoringDuration = scoringDuration_;\n', '        noContestTime = noContestTime_;\n', '        maxSubmissions = maxSubmissions_;\n', '        tournamentDataIPFSHash = tournamentDataIPFSHash_;\n', '        resultsOracle = FederatedOracleBytes8(oracleAddress);\n', '\t}\n', '\n', '    function submitBracket(bytes32 commitment) payable {\n', '        if (msg.value != entryFee) {\n', '            throw;\n', '        }\n', '        if (now >= tournamentStartTime) {\n', '            throw;\n', '        }\n', '        if (numSubmissions >= maxSubmissions) {\n', '            throw;\n', '        }\n', '\n', '        var submission = submissions[msg.sender];\n', '        if (submission.commitment != 0) {\n', '            throw;\n', '        }\n', '\n', '        submission.commitment = commitment;\n', '        numSubmissions++;\n', '        SubmissionAccepted(msg.sender);\n', '    }\n', '\n', '    function startScoring() returns (bool) {\n', '        if (results != 0) {\n', '            return false;\n', '        }\n', '        if (now < tournamentStartTime) {\n', '            return false;\n', '        }\n', '        if (now > noContestTime) {\n', '            return false;\n', '        }\n', '\n', '        bytes8 oracleValue = resultsOracle.finalValue();\n', '        if (oracleValue == 0) {\n', '            return false;\n', '        }\n', '\n', '        results = oracleValue;\n', '        scoringMask = ByteBracket.getScoringMask(results);\n', '        contestOverTime = now + scoringDuration;\n', '        TournamentOver();\n', '        return true;\n', '    }\n', '\n', '    function revealBracket(bytes8 bracket, bytes16 salt) returns (bool) {\n', '        var submission = submissions[msg.sender];\n', '        if (sha3(msg.sender, bracket, salt) != submission.commitment) {\n', '            return false;\n', '        }\n', '\n', '        submission.bracket = bracket;\n', '        return true;\n', '    }\n', '\n', '    function scoreBracket(address account) returns (bool) {\n', '        if (results == 0) {\n', '            return false;\n', '        }\n', '        if (now >= contestOverTime) {\n', '            return false;\n', '        }\n', '\n', '        var submission = submissions[account];\n', '        if (submission.bracket == 0) {\n', '            return false;\n', '        }\n', '        if (submission.score != 0) {\n', '            return false;\n', '        }\n', '\n', '        submission.score = ByteBracket.getBracketScore(submission.bracket, results, scoringMask);\n', '\n', '        if (submission.score > winningScore) {\n', '            winningScore = submission.score;\n', '            numWinners = 0;\n', '        }\n', '        if (submission.score == winningScore) {\n', '            numWinners++;\n', '            winnings = this.balance / numWinners;\n', '            NewWinner(account, submission.score);\n', '        }\n', '\n', '        return true;\n', '    }\n', '\n', '    function collectWinnings() returns (bool) {\n', '        if (now < contestOverTime) {\n', '            return false;\n', '        }\n', '\n', '        var submission = submissions[msg.sender];\n', '        if (submission.score != winningScore) {\n', '            return false;\n', '        }\n', '        if (submission.collectedWinnings) {\n', '            return false;\n', '        }\n', '\n', '        submission.collectedWinnings = true;\n', '\n', '        if (!msg.sender.send(winnings)) {\n', '            throw;\n', '        }\n', '\n', '        return true;\n', '    }\n', '\n', '    function collectEntryFee() returns (bool) {\n', '        if (now < noContestTime) {\n', '            return false;\n', '        }\n', '        if (results != 0) {\n', '            return false;\n', '        }\n', '\n', '        var submission = submissions[msg.sender];\n', '        if (submission.commitment == 0) {\n', '            return false;\n', '        }\n', '        if (submission.collectedEntryFee) {\n', '            return false;\n', '        }\n', '\n', '        submission.collectedEntryFee = true;\n', '\n', '        if (!msg.sender.send(entryFee)) {\n', '            throw;\n', '        }\n', '\n', '        return true;\n', '    }\n', '\n', '    function getBracketScore(bytes8 bracket) constant returns (uint8) {\n', '        if (results == 0) {\n', '            throw;\n', '        }\n', '        return ByteBracket.getBracketScore(bracket, results, scoringMask);\n', '    }\n', '\n', '    function getBracket(address account) constant returns (bytes8) {\n', '        return submissions[account].bracket;\n', '    }\n', '\n', '    function getScore(address account) constant returns (uint8) {\n', '        return submissions[account].score;\n', '    }\n', '\n', '    function getCommitment(address account) constant returns (bytes32) {\n', '        return submissions[account].commitment;\n', '    }\n', '\n', '    function hasCollectedWinnings(address account) constant returns (bool) {\n', '        return submissions[account].collectedWinnings;\n', '    }\n', '}']