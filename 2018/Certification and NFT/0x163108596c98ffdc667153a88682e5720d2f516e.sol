['/*\n', '\n', '     (       )    )    )\n', '     )\\ ) ( /( ( /( ( /(     (  (\n', '    (()/( )\\()))\\()))\\())  ( )\\ )\\\n', '     /(_)|(_)\\((_)\\((_)\\  ))((_|(_)\n', '    (_))  _((_)_((_)_((_)/((_)  _\n', '    | _ \\| || \\ \\/ / || (_))| || |\n', '    |  _/| __ |>  <| __ / -_) || |\n', '    |_|  |_||_/_/\\_\\_||_\\___|_||_|\n', '\n', '    PHXHell - A game of timing and luck.\n', '      made by ToCsIcK\n', '\n', '    Inspired by EthAnte by TechnicalRise\n', '\n', '*/\n', 'pragma solidity ^0.4.21;\n', '\n', '// Contract must implement this interface in order to receive ERC223 tokens\n', 'contract ERC223ReceivingContract {\n', '    function tokenFallback(address _from, uint _value, bytes _data) public;\n', '}\n', '\n', '// We only need the signature of the transfer method\n', 'contract ERC223Interface {\n', '    function transfer(address _to, uint _value) public returns (bool);\n', '}\n', '\n', '// SafeMath is good\n', 'library SafeMath {\n', '    function mul(uint a, uint b) internal pure returns (uint) {\n', '        uint c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint a, uint b) internal pure returns (uint) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return c;\n', '    }\n', '\n', '    function sub(uint a, uint b) internal pure returns (uint) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint a, uint b) internal pure returns (uint) {\n', '        uint c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '\n', '    function max64(uint64 a, uint64 b) internal pure returns (uint64) {\n', '        return a >= b ? a : b;\n', '    }\n', '\n', '    function min64(uint64 a, uint64 b) internal pure returns (uint64) {\n', '        return a < b ? a : b;\n', '    }\n', '\n', '    function max256(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a >= b ? a : b;\n', '    }\n', '\n', '    function min256(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a < b ? a : b;\n', '    }\n', '}\n', '\n', 'contract PhxHell is ERC223ReceivingContract {\n', '    using SafeMath for uint;\n', '\n', '    uint public balance;        // Current balance\n', '    uint public lastFund;       // Time of last fund\n', '    address public lastFunder;  // Address of the last person who funded\n', '    address phxAddress;         // PHX main net address\n', '\n', '    uint constant public stakingRequirement = 5e17;   // 0.5 PHX\n', '    uint constant public period = 1 hours;\n', '\n', '    // Event to record the end of a game so it can be added to a &#39;history&#39; page\n', '    event GameOver(address indexed winner, uint timestamp, uint value);\n', '\n', '    // Takes PHX address as a parameter so you can point at another contract during testing\n', '    function PhxHell(address _phxAddress)\n', '        public {\n', '        phxAddress = _phxAddress;\n', '    }\n', '\n', '    // Called to force a payout without having to restake\n', '    function payout()\n', '        public {\n', '\n', '        // If there&#39;s no pending winner, don&#39;t do anything\n', '        if (lastFunder == 0)\n', '            return;\n', '\n', '        // If timer hasn&#39;t expire, don&#39;t do anything\n', '        if (now.sub(lastFund) < period)\n', '            return;\n', '\n', '        uint amount = balance;\n', '        balance = 0;\n', '\n', '        // Send the total balance to the last funder\n', '        ERC223Interface phx = ERC223Interface(phxAddress);\n', '        phx.transfer(lastFunder, amount);\n', '\n', '        // Fire event\n', '        GameOver( lastFunder, now, amount );\n', '\n', '        // Reset the winner\n', '        lastFunder = address(0);\n', '    }\n', '\n', '    // Called by the ERC223 contract (PHX) when sending tokens to this address\n', '    function tokenFallback(address _from, uint _value, bytes)\n', '    public {\n', '\n', '        // Make sure it is PHX we are receiving\n', '        require(msg.sender == phxAddress);\n', '\n', '        // Make sure it&#39;s enough PHX\n', '        require(_value >= stakingRequirement);\n', '\n', '        // Payout if someone won already\n', '        payout();\n', '\n', '        // Add to the balance and reset the timer\n', '        balance = balance.add(_value);\n', '        lastFund = now;\n', '        lastFunder = _from;\n', '    }\n', '}']
['/*\n', '\n', '     (       )    )    )\n', '     )\\ ) ( /( ( /( ( /(     (  (\n', '    (()/( )\\()))\\()))\\())  ( )\\ )\\\n', '     /(_)|(_)\\((_)\\((_)\\  ))((_|(_)\n', '    (_))  _((_)_((_)_((_)/((_)  _\n', '    | _ \\| || \\ \\/ / || (_))| || |\n', '    |  _/| __ |>  <| __ / -_) || |\n', '    |_|  |_||_/_/\\_\\_||_\\___|_||_|\n', '\n', '    PHXHell - A game of timing and luck.\n', '      made by ToCsIcK\n', '\n', '    Inspired by EthAnte by TechnicalRise\n', '\n', '*/\n', 'pragma solidity ^0.4.21;\n', '\n', '// Contract must implement this interface in order to receive ERC223 tokens\n', 'contract ERC223ReceivingContract {\n', '    function tokenFallback(address _from, uint _value, bytes _data) public;\n', '}\n', '\n', '// We only need the signature of the transfer method\n', 'contract ERC223Interface {\n', '    function transfer(address _to, uint _value) public returns (bool);\n', '}\n', '\n', '// SafeMath is good\n', 'library SafeMath {\n', '    function mul(uint a, uint b) internal pure returns (uint) {\n', '        uint c = a * b;\n', '        assert(a == 0 || c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint a, uint b) internal pure returns (uint) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '    function sub(uint a, uint b) internal pure returns (uint) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint a, uint b) internal pure returns (uint) {\n', '        uint c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '\n', '    function max64(uint64 a, uint64 b) internal pure returns (uint64) {\n', '        return a >= b ? a : b;\n', '    }\n', '\n', '    function min64(uint64 a, uint64 b) internal pure returns (uint64) {\n', '        return a < b ? a : b;\n', '    }\n', '\n', '    function max256(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a >= b ? a : b;\n', '    }\n', '\n', '    function min256(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return a < b ? a : b;\n', '    }\n', '}\n', '\n', 'contract PhxHell is ERC223ReceivingContract {\n', '    using SafeMath for uint;\n', '\n', '    uint public balance;        // Current balance\n', '    uint public lastFund;       // Time of last fund\n', '    address public lastFunder;  // Address of the last person who funded\n', '    address phxAddress;         // PHX main net address\n', '\n', '    uint constant public stakingRequirement = 5e17;   // 0.5 PHX\n', '    uint constant public period = 1 hours;\n', '\n', "    // Event to record the end of a game so it can be added to a 'history' page\n", '    event GameOver(address indexed winner, uint timestamp, uint value);\n', '\n', '    // Takes PHX address as a parameter so you can point at another contract during testing\n', '    function PhxHell(address _phxAddress)\n', '        public {\n', '        phxAddress = _phxAddress;\n', '    }\n', '\n', '    // Called to force a payout without having to restake\n', '    function payout()\n', '        public {\n', '\n', "        // If there's no pending winner, don't do anything\n", '        if (lastFunder == 0)\n', '            return;\n', '\n', "        // If timer hasn't expire, don't do anything\n", '        if (now.sub(lastFund) < period)\n', '            return;\n', '\n', '        uint amount = balance;\n', '        balance = 0;\n', '\n', '        // Send the total balance to the last funder\n', '        ERC223Interface phx = ERC223Interface(phxAddress);\n', '        phx.transfer(lastFunder, amount);\n', '\n', '        // Fire event\n', '        GameOver( lastFunder, now, amount );\n', '\n', '        // Reset the winner\n', '        lastFunder = address(0);\n', '    }\n', '\n', '    // Called by the ERC223 contract (PHX) when sending tokens to this address\n', '    function tokenFallback(address _from, uint _value, bytes)\n', '    public {\n', '\n', '        // Make sure it is PHX we are receiving\n', '        require(msg.sender == phxAddress);\n', '\n', "        // Make sure it's enough PHX\n", '        require(_value >= stakingRequirement);\n', '\n', '        // Payout if someone won already\n', '        payout();\n', '\n', '        // Add to the balance and reset the timer\n', '        balance = balance.add(_value);\n', '        lastFund = now;\n', '        lastFunder = _from;\n', '    }\n', '}']