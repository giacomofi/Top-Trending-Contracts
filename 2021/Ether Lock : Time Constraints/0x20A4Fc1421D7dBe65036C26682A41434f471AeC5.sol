['// SPDX-License-Identifier: GPL-2.0-only\n', 'pragma solidity ^0.8.0;\n', '\n', 'import "./IERC20.sol";\n', 'import "./RoleAware.sol";\n', 'import "./Fund.sol";\n', '\n', 'struct Claim {\n', '    uint256 startingRewardRateFP;\n', '    address recipient;\n', '    uint256 amount;\n', '}\n', '\n', 'contract IncentiveDistribution is RoleAware, Ownable {\n', '    // fixed point number factor\n', '    uint256 constant FP32 = 2**32;\n', '    // the amount of contraction per thousand, per day\n', '    // of the overal daily incentive distribution\n', '    uint256 constant contractionPerMil = 999;\n', '    // the period for which claims are batch updated\n', '    uint256 constant period = 4 hours;\n', '    uint256 constant periodsPerDay = 24 hours / period;\n', '    address MFI;\n', '\n', '    constructor(\n', '        address _MFI,\n', '        uint256 startingDailyDistributionWithoutDecimals,\n', '        address _roles\n', '    ) RoleAware(_roles) Ownable() {\n', '        MFI = _MFI;\n', '        currentDailyDistribution =\n', '            startingDailyDistributionWithoutDecimals *\n', '            (1 ether);\n', '        lastDailyDistributionUpdate = block.timestamp / (1 days);\n', '    }\n', '\n', '    // how much is going to be distributed, contracts every day\n', '    uint256 public currentDailyDistribution;\n', '    // last day on which we updated currentDailyDistribution\n', '    uint256 lastDailyDistributionUpdate;\n', '    // portion of daily distribution per each tranche\n', '    mapping(uint8 => uint256) public trancheShare;\n', '    uint256 public trancheShareTotal;\n', '\n', "    // tranche => claim totals for the period we're currently aggregating\n", '    mapping(uint8 => uint256) public currentPeriodTotals;\n', '    // tranche => timestamp / period of last update\n', '    mapping(uint8 => uint256) public lastUpdatedPeriods;\n', '\n', '    // how each claim unit would get if they had staked from the dawn of time\n', '    // expressed as fixed point number\n', '    // claim amounts are expressed relative to this ongoing aggregate\n', '    mapping(uint8 => uint256) public aggregatePeriodicRewardRateFP;\n', '    // claim records\n', '    mapping(uint256 => Claim) public claims;\n', '    uint256 public nextClaimId = 1;\n', '\n', '    function setTrancheShare(uint8 tranche, uint256 share) external onlyOwner {\n', '        require(\n', '            lastUpdatedPeriods[tranche] > 0,\n', '            "Tranche is not initialized, please initialize first"\n', '        );\n', '        _setTrancheShare(tranche, share);\n', '    }\n', '\n', '    function _setTrancheShare(uint8 tranche, uint256 share) internal {\n', '        if (share > trancheShare[tranche]) {\n', '            trancheShareTotal += share - trancheShare[tranche];\n', '        } else {\n', '            trancheShareTotal -= trancheShare[tranche] - share;\n', '        }\n', '        trancheShare[tranche] = share;\n', '    }\n', '\n', '    function initTranche(\n', '        uint8 tranche,\n', '        uint256 share\n', '    ) external onlyOwner {\n', '        _setTrancheShare(tranche, share);\n', '\n', '        lastUpdatedPeriods[tranche] = block.timestamp / period;\n', '        // simply initialize to 1.0\n', '        aggregatePeriodicRewardRateFP[tranche] = FP32;\n', '    }\n', '\n', '    function updatePeriodTotals(uint8 tranche) internal {\n', '        uint256 currentPeriod = block.timestamp / period;\n', '\n', '        // update the amount that gets distributed per day, if there has been\n', '        // a day transition\n', '        updateCurrentDailyDistribution();\n', '        // Do a bunch of updating of periodic variables when the period changes\n', '        uint256 lU = lastUpdatedPeriods[tranche];\n', '        uint256 periodDiff = currentPeriod - lU;\n', '\n', '        if (periodDiff > 0) {\n', '            aggregatePeriodicRewardRateFP[tranche] +=\n', '                currentPeriodicRewardRateFP(tranche) *\n', '                periodDiff;\n', '        }\n', '\n', '        lastUpdatedPeriods[tranche] = currentPeriod;\n', '    }\n', '\n', '    function forcePeriodTotalUpdate(uint8 tranche) external {\n', '        updatePeriodTotals(tranche);\n', '    }\n', '\n', '    function updateCurrentDailyDistribution() internal {\n', '        uint256 nowDay = block.timestamp / (1 days);\n', '        uint256 dayDiff = nowDay - lastDailyDistributionUpdate;\n', '\n', '        // shrink the daily distribution for every day that has passed\n', '        for (uint256 i = 0; i < dayDiff; i++) {\n', '            currentDailyDistribution =\n', '                (currentDailyDistribution * contractionPerMil) /\n', '                1000;\n', '        }\n', '        // now update this memo\n', '        lastDailyDistributionUpdate = nowDay;\n', '    }\n', '\n', '    function currentPeriodicRewardRateFP(uint8 tranche)\n', '        internal\n', '        view\n', '        returns (uint256)\n', '    {\n', '        // scale daily distribution down to tranche share\n', '        uint256 tranchePeriodDistributionFP =\n', '            FP32 * currentDailyDistribution * trancheShare[tranche] / trancheShareTotal / periodsPerDay;\n', '\n', '        // rate = (total_reward / total_claims) per period\n', '        return\n', '            tranchePeriodDistributionFP /\n', '            currentPeriodTotals[tranche];\n', '    }\n', '\n', '    function startClaim(\n', '        uint8 tranche,\n', '        address recipient,\n', '        uint256 claimAmount\n', '    ) external returns (uint256) {\n', '        require(\n', '            isIncentiveReporter(msg.sender),\n', '            "Contract not authorized to report incentives"\n', '        );\n', '        if (currentDailyDistribution > 0) {\n', '            updatePeriodTotals(tranche);\n', '\n', '            currentPeriodTotals[tranche] += claimAmount;\n', '\n', '            claims[nextClaimId] = Claim({\n', '                startingRewardRateFP: aggregatePeriodicRewardRateFP[tranche],\n', '                recipient: recipient,\n', '                amount: claimAmount\n', '            });\n', '            nextClaimId += 1;\n', '            return nextClaimId - 1;\n', '        } else {\n', '            return 0;\n', '        }\n', '    }\n', '\n', '    function addToClaimAmount(\n', '        uint8 tranche,\n', '        uint256 claimId,\n', '        uint256 additionalAmount\n', '    ) external {\n', '        require(\n', '            isIncentiveReporter(msg.sender),\n', '            "Contract not authorized to report incentives"\n', '        );\n', '        if (currentDailyDistribution > 0) {\n', '            updatePeriodTotals(tranche);\n', '\n', '            currentPeriodTotals[tranche] += additionalAmount;\n', '\n', '            Claim storage claim = claims[claimId];\n', '            require(\n', '                claim.startingRewardRateFP > 0,\n', '                "Trying to add to non-existant claim"\n', '            );\n', '            _withdrawReward(tranche, claim);\n', '            claim.amount += additionalAmount;\n', '        }\n', '    }\n', '\n', '    function subtractFromClaimAmount(\n', '        uint8 tranche,\n', '        uint256 claimId,\n', '        uint256 subtractAmount\n', '    ) external {\n', '        require(\n', '            isIncentiveReporter(msg.sender),\n', '            "Contract not authorized to report incentives"\n', '        );\n', '        updatePeriodTotals(tranche);\n', '\n', '        currentPeriodTotals[tranche] -= subtractAmount;\n', '\n', '        Claim storage claim = claims[claimId];\n', '        _withdrawReward((tranche), claim);\n', '        claim.amount -= subtractAmount;\n', '    }\n', '\n', '    function endClaim(uint8 tranche, uint256 claimId) external {\n', '        require(\n', '            isIncentiveReporter(msg.sender),\n', '            "Contract not authorized to report incentives"\n', '        );\n', '        updatePeriodTotals(tranche);\n', '        Claim storage claim = claims[claimId];\n', '\n', '        if (claim.startingRewardRateFP > 0) {\n', '            _withdrawReward(tranche, claim);\n', '            delete claim.recipient;\n', '            delete claim.startingRewardRateFP;\n', '            delete claim.amount;\n', '        }\n', '    }\n', '\n', '    function calcRewardAmount(uint8 tranche, Claim storage claim)\n', '        internal\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return\n', '            (claim.amount *\n', '                (aggregatePeriodicRewardRateFP[tranche] -\n', '                    claim.startingRewardRateFP)) / FP32;\n', '    }\n', '\n', '    function viewRewardAmount(uint8 tranche, uint256 claimId)\n', '        external\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return calcRewardAmount(tranche, claims[claimId]);\n', '    }\n', '\n', '    function withdrawReward(uint8 tranche, uint256 claimId)\n', '        external\n', '        returns (uint256)\n', '    {\n', '        require(\n', '            isIncentiveReporter(msg.sender),\n', '            "Contract not authorized to report incentives"\n', '        );\n', '        updatePeriodTotals(tranche);\n', '        Claim storage claim = claims[claimId];\n', '        return _withdrawReward(tranche, claim);\n', '    }\n', '\n', '    function _withdrawReward(uint8 tranche, Claim storage claim)\n', '        internal\n', '        returns (uint256 rewardAmount)\n', '    {\n', '        rewardAmount = calcRewardAmount(tranche, claim);\n', '\n', '        require(\n', '            Fund(fund()).withdraw(MFI, claim.recipient, rewardAmount),\n', '            "There seems to be a lack of MFI in the incentive fund!"\n', '        );\n', '\n', '        claim.startingRewardRateFP = aggregatePeriodicRewardRateFP[tranche];\n', '    }\n', '}']