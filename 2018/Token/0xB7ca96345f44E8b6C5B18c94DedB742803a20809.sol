['//File: contracts/common/Controlled.sol\n', 'pragma solidity ^0.4.21;\n', '\n', 'contract Controlled {\n', '    modifier onlyController { require(msg.sender == controller); _; }\n', '\n', '    address public controller;\n', '\n', '    function Controlled() public { controller = msg.sender;}\n', '\n', '    function changeController(address _newController) public onlyController {\n', '        controller = _newController;\n', '    }\n', '}\n', '\n', '//File: contracts/common/TokenController.sol\n', 'pragma solidity ^0.4.21;\n', '\n', 'contract TokenController {\n', '    function proxyPayment(address _owner) public payable returns(bool);\n', '\n', '    function onTransfer(address _from, address _to, uint _amount) public returns(bool);\n', '\n', '    function onApprove(address _owner, address _spender, uint _amount) public returns(bool);\n', '}\n', '\n', '//File: contracts/common/ApproveAndCallFallBack.sol\n', 'pragma solidity ^0.4.21;\n', '\n', 'contract ApproveAndCallFallBack {\n', '    function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public;\n', '}\n', '\n', '//File: ./contracts/Token.sol\n', 'pragma solidity ^0.4.21;\n', '\n', '\n', '\n', '\n', '\n', '\n', 'contract Token is Controlled {\n', '\n', '    string public name = "ShineCoin";\n', '    uint8 public decimals = 9;\n', '    string public symbol = "SHINE";\n', '\n', '    struct  Checkpoint {\n', '        uint128 fromBlock;\n', '        uint128 value;\n', '    }\n', '\n', '    uint public creationBlock;\n', '\n', '    mapping (address => Checkpoint[]) balances;\n', '\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\n', '    Checkpoint[] totalSupplyHistory;\n', '\n', '    bool public transfersEnabled = true;\n', '\n', '    address public frozenReserveTeamWallet;\n', '\n', '    uint public unfreezeTeamWalletBlock;\n', '\n', '    function Token(address _frozenReserveTeamWallet) public {\n', '        creationBlock = block.number;\n', '        frozenReserveTeamWallet = _frozenReserveTeamWallet;\n', '        unfreezeTeamWalletBlock = block.number + ((365 * 24 * 3600) / 15); // ~ 396 days\n', '    }\n', '\n', '\n', '///////////////////\n', '// ERC20 Methods\n', '///////////////////\n', '\n', '    function transfer(address _to, uint256 _amount) public returns (bool success) {\n', '        require(transfersEnabled);\n', '\n', '        if (address(msg.sender) == frozenReserveTeamWallet) {\n', '            require(block.number > unfreezeTeamWalletBlock);\n', '        }\n', '\n', '        doTransfer(msg.sender, _to, _amount);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {\n', '        if (msg.sender != controller) {\n', '            require(transfersEnabled);\n', '\n', '            require(allowed[_from][msg.sender] >= _amount);\n', '            allowed[_from][msg.sender] -= _amount;\n', '        }\n', '        doTransfer(_from, _to, _amount);\n', '        return true;\n', '    }\n', '\n', '\n', '    function doTransfer(address _from, address _to, uint _amount) internal {\n', '\n', '           if (_amount <= 0) {\n', '               emit Transfer(_from, _to, _amount);\n', '               return;\n', '           }\n', '\n', '           require((_to != 0) && (_to != address(this)));\n', '\n', '           uint256 previousBalanceFrom = balanceOfAt(_from, block.number);\n', '\n', '           require(previousBalanceFrom >= _amount);\n', '\n', '           updateValueAtNow(balances[_from], previousBalanceFrom - _amount);\n', '\n', '           uint256 previousBalanceTo = balanceOfAt(_to, block.number);\n', '           require(previousBalanceTo + _amount >= previousBalanceTo);\n', '           updateValueAtNow(balances[_to], previousBalanceTo + _amount);\n', '\n', '           emit Transfer(_from, _to, _amount);\n', '\n', '    }\n', '\n', '    function balanceOf(address _owner) public constant returns (uint256 balance) {\n', '        return balanceOfAt(_owner, block.number);\n', '    }\n', '\n', '    function approve(address _spender, uint256 _amount) public returns (bool success) {\n', '        require(transfersEnabled);\n', '\n', '        require((_amount == 0) || (allowed[msg.sender][_spender] == 0));\n', '\n', '        if (isContract(controller)) {\n', '            require(TokenController(controller).onApprove(msg.sender, _spender, _amount));\n', '        }\n', '\n', '        allowed[msg.sender][_spender] = _amount;\n', '        emit Approval(msg.sender, _spender, _amount);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    function approveAndCall(address _spender, uint256 _amount, bytes _extraData\n', '    ) public returns (bool success) {\n', '        require(approve(_spender, _amount));\n', '\n', '        ApproveAndCallFallBack(_spender).receiveApproval(\n', '            msg.sender,\n', '            _amount,\n', '            this,\n', '            _extraData\n', '        );\n', '\n', '        return true;\n', '    }\n', '\n', '    function totalSupply() public constant returns (uint) {\n', '        return totalSupplyAt(block.number);\n', '    }\n', '\n', '    function balanceOfAt(address _owner, uint _blockNumber) public constant returns (uint) {\n', '\n', '        if ((balances[_owner].length == 0)\n', '            || (balances[_owner][0].fromBlock > _blockNumber)) {\n', '            return 0;\n', '        } else {\n', '            return getValueAt(balances[_owner], _blockNumber);\n', '        }\n', '    }\n', '\n', '    function totalSupplyAt(uint _blockNumber) public constant returns(uint) {\n', '\n', '        if ((totalSupplyHistory.length == 0)\n', '            || (totalSupplyHistory[0].fromBlock > _blockNumber)) {\n', '            return 0;\n', '\n', '        } else {\n', '            return getValueAt(totalSupplyHistory, _blockNumber);\n', '        }\n', '    }\n', '\n', '    function generateTokens(address _owner, uint _amount) public onlyController returns (bool) {\n', '        uint curTotalSupply = totalSupply();\n', '        require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow\n', '        uint previousBalanceTo = balanceOf(_owner);\n', '        require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow\n', '        updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);\n', '        updateValueAtNow(balances[_owner], previousBalanceTo + _amount);\n', '        emit Transfer(0, _owner, _amount);\n', '        return true;\n', '    }\n', '\n', '    function destroyTokens(address _owner, uint _amount) onlyController public returns (bool) {\n', '        uint curTotalSupply = totalSupply();\n', '        require(curTotalSupply >= _amount);\n', '        uint previousBalanceFrom = balanceOf(_owner);\n', '        require(previousBalanceFrom >= _amount);\n', '        updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);\n', '        updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);\n', '        emit Transfer(_owner, 0, _amount);\n', '        return true;\n', '    }\n', '\n', '    function enableTransfers(bool _transfersEnabled) public onlyController {\n', '        transfersEnabled = _transfersEnabled;\n', '    }\n', '\n', '\n', '    function getValueAt(Checkpoint[] storage checkpoints, uint _block) constant internal returns (uint) {\n', '        if (checkpoints.length == 0) return 0;\n', '\n', '        if (_block >= checkpoints[checkpoints.length-1].fromBlock)\n', '            return checkpoints[checkpoints.length-1].value;\n', '        if (_block < checkpoints[0].fromBlock) return 0;\n', '\n', '        uint min = 0;\n', '        uint max = checkpoints.length-1;\n', '        while (max > min) {\n', '            uint mid = (max + min + 1)/ 2;\n', '            if (checkpoints[mid].fromBlock<=_block) {\n', '                min = mid;\n', '            } else {\n', '                max = mid-1;\n', '            }\n', '        }\n', '        return checkpoints[min].value;\n', '    }\n', '\n', '    function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value) internal  {\n', '        if ((checkpoints.length == 0)\n', '        || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {\n', '               Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];\n', '               newCheckPoint.fromBlock =  uint128(block.number);\n', '               newCheckPoint.value = uint128(_value);\n', '           } else {\n', '               Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];\n', '               oldCheckPoint.value = uint128(_value);\n', '           }\n', '    }\n', '\n', '    function isContract(address _addr) constant internal returns(bool) {\n', '        uint size;\n', '        if (_addr == 0) return false;\n', '        assembly {\n', '            size := extcodesize(_addr)\n', '        }\n', '        return size>0;\n', '    }\n', '\n', '    function min(uint a, uint b) pure internal returns (uint) {\n', '        return a < b ? a : b;\n', '    }\n', '\n', '    function () public payable {\n', '        require(isContract(controller));\n', '        require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));\n', '    }\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _amount);\n', '    event Approval(\n', '        address indexed _owner,\n', '        address indexed _spender,\n', '        uint256 _amount\n', '        );\n', '\n', '}']