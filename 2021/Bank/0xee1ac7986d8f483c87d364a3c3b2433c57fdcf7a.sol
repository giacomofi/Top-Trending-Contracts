['pragma solidity ^0.8.4;\n', '\n', 'import "./ERC20.sol";\n', 'import "./SafeMath.sol";\n', 'import "./Ownable.sol";\n', '\n', '/**\n', ' * @title Staking Token (STK)\n', ' * @author Alberto Cuesta Canada\n', ' * @notice Implements a basic ERC20 staking token with incentive distribution.\n', ' */\n', 'contract StakingToken is ERC20, Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    /**\n', '     * @notice We usually require to know who are all the stakeholders.\n', '     */\n', '    address[] internal stakeholders;\n', '\n', '    /**\n', '     * @notice The stakes for each stakeholder.\n', '     */\n', '    mapping(address => uint256) internal stakes;\n', '\n', '    mapping (address => uint256) private _lastDividends;\n', '\n', '    uint256 _totalSupply = 1000000000000;\n', '    uint256 totalDividends = 0;\n', '    uint256 unclaimedDividends = 0;\n', '\n', '    modifier updateDividend(address investor) {\n', '        uint256 owing = dividendsOwing(investor);\n', '\n', '        if (owing > 0) {\n', '            unclaimedDividends = unclaimedDividends.sub(owing);\n', '            _mint(investor, owing);\n', '            //_updateBalance(investor, balanceOf(investor).add(owing));\n', '            _lastDividends[investor] = totalDividends;\n', '        }\n', '     _;\n', '    }\n', '\n', '    function dividendsOwing(address investor) internal returns(uint256) {\n', '        uint256 totalUsersBalance = _totalSupply.sub(balanceOf(owner()));\n', '        uint256 newDividends = totalDividends.sub(_lastDividends[investor]);\n', '        \n', '        if (newDividends == 0 || balanceOf(investor) == 0 || totalUsersBalance == 0) {\n', '            return 0;\n', '        }\n', '        \n', '        uint256 owingPercent = balanceOf(investor).mul(100).div(totalUsersBalance);\n', '        return owingPercent.mul(newDividends).div(100);\n', '    }\n', '\n', '    function disburse(uint256 amount) onlyOwner public {\n', '        _burn(owner(), amount);\n', '        \n', '        totalDividends = totalDividends.add(amount);\n', '        unclaimedDividends =  unclaimedDividends.add(amount);\n', '    }\n', '\n', '    function claimDividend() public {\n', '        address investor = msg.sender;\n', '        uint256 owing = dividendsOwing(investor);\n', '\n', '        if (owing > 0) {\n', '            unclaimedDividends = unclaimedDividends.sub(owing);\n', '            _mint(investor, owing);\n', '            _lastDividends[investor] = totalDividends;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @notice The accumulated rewards for each stakeholder.\n', '     */\n', '    mapping(address => uint256) internal rewards;\n', '    \n', '    constructor(address _owner) ERC20("Dividend Elite", "DIVIDEND")\n', '        public\n', '    { \n', '        _mint(_owner, _totalSupply);\n', '    }\n', '\n', '    function totalSupply() public view override returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    function decimals() public view override returns (uint8) {\n', '        return 0;\n', '    }\n', '}']