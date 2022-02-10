['pragma solidity ^0.4.14;\n', '\n', 'contract Totalizeum {\n', '    enum MarketState { Initial, Resolving, Resolved, Unresolved }\n', '\n', '    struct Market {\n', '        MarketState state;\n', '        uint256 balance;\n', '        Resolve resolve;\n', '        Settings settings;\n', '        mapping (uint256 => Outcome) outcomes;\n', '    }\n', '\n', '    struct Outcome {\n', '        uint256 balance;\n', '        bool won;\n', '        mapping (address => uint256) bets;\n', '    }\n', '\n', '    struct Resolve {\n', '        uint256 remainingBalance;\n', '        uint256 winningBalance;\n', '        uint256 winningOutcomes;\n', '    }\n', '\n', '    struct Settings {\n', '        uint256 refundDelay;\n', '        uint256 share;\n', '    }\n', '\n', '    string public constant symbol = "TOT";\n', '\n', '    string public constant name = "Totalizeum";\n', '\n', '    uint8 public constant decimals = 18;\n', '\n', '    uint256 public constant totalSupply = (uint256(10) ** 6) *\n', '        (uint256(10) ** decimals);\n', '\n', '    Settings private defaultSettings = Settings(1 days, 980);\n', '\n', '    uint256 private constant sub = 1000000;\n', '\n', '    mapping (address => uint256) balances;\n', '\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\n', '    mapping (address => mapping(uint256 => Market)) markets;\n', '\n', '    mapping (address => Settings) oracleSettings;\n', '\n', '    mapping (address => mapping (address => bool)) public successor;\n', '\n', '    uint256 public sellable = totalSupply;\n', '\n', '    address public owner;\n', '\n', '    function Totalizeum() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    function balanceOf(address _owner) constant returns (uint256) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function transfer(address _to, uint256 _amount) returns (bool) {\n', '        require(msg.data.length >= (2 * 32) + 4);\n', '\n', '        if (balances[msg.sender] >= _amount &&\n', '            _amount > 0 &&\n', '            balances[_to] + _amount > balances[_to]) {\n', '\n', '            balances[msg.sender] -= _amount;\n', '            balances[_to] += _amount;\n', '\n', '            Transfer(msg.sender, _to, _amount);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    function transferFrom(\n', '        address _from, address _to, uint256 _amount\n', '    ) returns (bool) {\n', '        require(msg.data.length >= (3 * 32) + 4);\n', '\n', '        if (balances[_from] >= _amount &&\n', '            _amount > 0 &&\n', '            allowed[_from][msg.sender] >= _amount &&\n', '            balances[_to] + _amount > balances[_to]) {\n', '\n', '            balances[_from] -= _amount;\n', '            allowed[_from][msg.sender] -= _amount;\n', '            balances[_to] += _amount;\n', '\n', '            Transfer(_from, _to, _amount);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    function approve(address _spender, uint256 _amount) returns (bool) {\n', '        require((_amount == 0) || (allowed[msg.sender][_spender] == 0));\n', '\n', '        allowed[msg.sender][_spender] = _amount;\n', '\n', '        Approval(msg.sender, _spender, _amount);\n', '        return true;\n', '    }\n', '\n', '    function allowance(\n', '        address _owner, address _spender\n', '    ) constant returns (uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    function bet(\n', '        address _oracle, uint256 _timestamp, uint256 _outcome, uint256 _amount\n', '    ) returns (bool) {\n', '        Market storage market = markets[_oracle][_timestamp];\n', '        Outcome storage outcome = market.outcomes[_outcome];\n', '\n', '        if (balances[msg.sender] >= _amount &&\n', '            _amount > 0 &&\n', '            now < _timestamp &&\n', '            market.state == MarketState.Initial &&\n', '            market.balance + _amount > market.balance &&\n', '            (market.balance + _amount) * sub / sub\n', '                == (market.balance + _amount) &&\n', '            outcome.balance + _amount > outcome.balance &&\n', '            outcome.bets[msg.sender] + _amount > outcome.bets[msg.sender]) {\n', '\n', '            if (market.balance == 0) {\n', '                Settings storage settings = oracleSettings[_oracle];\n', '\n', '                if (settings.refundDelay > 0) {\n', '\n', '                    market.settings = settings;\n', '                } else {\n', '                    market.settings = defaultSettings;\n', '                }\n', '            }\n', '\n', '            balances[msg.sender] -= _amount;\n', '            market.balance += _amount;\n', '            outcome.balance += _amount;\n', '            outcome.bets[msg.sender] += _amount;\n', '\n', '            Bet(msg.sender, _oracle, _timestamp, _outcome, _amount);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    function resolve(\n', '        uint256 _timestamp, uint256 _outcome, bool _final\n', '    ) returns (bool) {\n', '        Market storage market = markets[msg.sender][_timestamp];\n', '        Outcome storage outcome = market.outcomes[_outcome];\n', '        Resolve storage _resolve = market.resolve;\n', '        Settings storage settings = market.settings;\n', '\n', '        if (market.state == MarketState.Initial) {\n', '\n', '            market.state = MarketState.Resolving;\n', '            _resolve.remainingBalance = market.balance;\n', '        }\n', '\n', '        if (market.state == MarketState.Resolving &&\n', '            now >= _timestamp &&\n', '            market.balance > 0) {\n', '\n', '            if (!outcome.won &&\n', '                outcome.balance > 0) {\n', '\n', '                outcome.won = true;\n', '                _resolve.winningBalance += outcome.balance;\n', '                _resolve.winningOutcomes += 1;\n', '            }\n', '\n', '            if (_final &&\n', '                _resolve.winningOutcomes > 0) {\n', '\n', '                uint256 share = market.balance - market.balance / 1000\n', '                    * settings.share;\n', '                \n', '                market.state = MarketState.Resolved;\n', '                _resolve.remainingBalance -= share;\n', '                balances[msg.sender] += share;\n', '            }\n', '\n', '            Resolved(msg.sender, _timestamp, _outcome, _final);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    function withdraw(\n', '        address _oracle, uint256 _timestamp, uint256 _outcome\n', '    ) returns (bool) {\n', '        Market storage market = markets[_oracle][_timestamp];\n', '        Outcome storage outcome = market.outcomes[_outcome];\n', '        Resolve storage _resolve = market.resolve;\n', '        Settings storage settings = market.settings;\n', '\n', '        if (outcome.bets[msg.sender] > 0) {\n', '            uint256 amount = outcome.bets[msg.sender];\n', '\n', '            if (market.state == MarketState.Resolved &&\n', '                outcome.won) {\n', '\n', '                uint256 share = market.balance * sub / 1000 * settings.share\n', '                    / _resolve.winningOutcomes / outcome.balance * amount\n', '                    / sub;\n', '\n', '                delete outcome.bets[msg.sender];\n', '                _resolve.winningBalance -= amount;\n', '                _resolve.remainingBalance -= share;\n', '                balances[msg.sender] += share;\n', '\n', '                Withdrawal(msg.sender, _oracle, _timestamp, _outcome, share);\n', '\n', '                if (_resolve.winningBalance == 0) {\n', '                    balances[_oracle] += _resolve.remainingBalance;\n', '                    delete _resolve.remainingBalance;\n', '                }\n', '\n', '                return true;\n', '            } else if ((market.state == MarketState.Initial ||\n', '                    market.state == MarketState.Resolving ||\n', '                    market.state == MarketState.Unresolved) &&\n', '                now >= _timestamp + settings.refundDelay) {\n', '\n', '                market.state = MarketState.Unresolved;\n', '\n', '                delete outcome.bets[msg.sender];\n', '                balances[msg.sender] += amount;\n', '\n', '                Withdrawal(msg.sender, _oracle, _timestamp, _outcome, amount);\n', '\n', '                return true;\n', '            } else {\n', '                return false;\n', '            }\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    function marketState(\n', '        address _oracle, uint256 _timestamp\n', '    ) constant returns (MarketState, uint256, uint256, uint256) {\n', '        Market storage market = markets[_oracle][_timestamp];\n', '        Resolve storage _resolve = market.resolve;\n', '\n', '        return (market.state, market.balance, _resolve.winningOutcomes,\n', '            _resolve.remainingBalance);\n', '    }\n', '\n', '    function outcomeState(\n', '        address _oracle, uint256 _timestamp, uint256 _outcome\n', '    ) constant returns (bool, uint256) {\n', '        Outcome storage outcome = markets[_oracle][_timestamp]\n', '            .outcomes[_outcome];\n', '\n', '        return (outcome.won, outcome.balance);\n', '    }\n', '\n', '    function setSettings(\n', '        uint256 _refundDelay, uint256 _share\n', '    ) returns (bool) {\n', '\n', '        if (_refundDelay > 0 &&\n', '            _refundDelay <= 28 days &&\n', '            _share <= 250) {\n', '\n', '            oracleSettings[msg.sender] = Settings(_refundDelay,\n', '                1000 - _share);\n', '            \n', '            SettingsSet(msg.sender, _refundDelay, _share);\n', '            return true;\n', '        } else {\n', '            return false;\n', '        }\n', '    }\n', '\n', '    function setSuccessor(address _successor) {\n', '        successor[_successor][msg.sender] = true;\n', '    }\n', '\n', '    function () payable {\n', '        uint256 amount = msg.value * 1000;\n', '\n', '        if (amount / 1000 == msg.value &&\n', '            amount <= sellable) {\n', '\n', '            owner.transfer(msg.value);\n', '            sellable -= amount;\n', '            balances[msg.sender] += amount;\n', '\n', '            Sale(msg.sender, amount);\n', '        } else {\n', '            revert();\n', '        }\n', '    }\n', '\n', '    function setOwner(address _owner) {\n', '        if (msg.sender == owner) {\n', '            owner = _owner;\n', '        }\n', '    }\n', '\n', '    event Transfer(address indexed _from, address indexed _to,\n', '        uint256 _amount);\n', '\n', '    event Approval(address indexed _owner, address indexed _spender,\n', '        uint256 _amount);\n', '\n', '    event Bet(address indexed _bettor, address indexed _oracle,\n', '        uint256 indexed _timestamp, uint256 _outcome, uint256 _amount);\n', '\n', '    event Resolved(address indexed _oracle, uint256 indexed _timestamp,\n', '        uint256 indexed _outcome, bool _final);\n', '\n', '    event Withdrawal(address indexed _bettor, address indexed _oracle,\n', '        uint256 indexed _timestamp, uint256 _outcome, uint256 _amount);\n', '\n', '    event Successor(address indexed _oracle, address indexed _successor);\n', '\n', '    event SettingsSet(address indexed _oracle, uint256 _refundDelay,\n', '        uint256 _share);\n', '\n', '    event Sale(address indexed _buyer, uint256 _amount);\n', '}']