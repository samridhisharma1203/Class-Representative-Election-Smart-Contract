// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VotingSystem {
    address public organizer;
    uint256 public totalVotes;
    bool public votingOpen;
    
    struct Voter {
        string name;
        bool hasVoted;
    }

    struct Candidate {
        string name;
        uint256 voteCount;
    }

    mapping(address => Voter) public voters;
    Candidate[] public candidates;

    event VoterRegistered(address indexed voter, string name);
    event Voted(address indexed voter, uint256 candidateIndex);

    modifier onlyOrganizer() {
        require(msg.sender == organizer, "Only the organizer can perform this action");
        _;
    }

    modifier isVotingOpen() {
        require(votingOpen, "Voting is closed");
        _;
    }

    constructor() {
        organizer = msg.sender;
        votingOpen = false;
    }

    function openVoting() public onlyOrganizer {
        votingOpen = true;
    }

    function closeVoting() public onlyOrganizer {
        votingOpen = false;
    }

    function registerVoter(string memory name) public {
        require(!voters[msg.sender].hasVoted, "You have already voted");
        voters[msg.sender] = Voter(name, false);
        emit VoterRegistered(msg.sender, name);
    }

    function addCandidate(string memory name) public onlyOrganizer isVotingOpen {
        candidates.push(Candidate(name, 0));
    }

    function vote(uint256 candidateIndex) public isVotingOpen {
        Voter storage voter = voters[msg.sender];
        require(!voter.hasVoted, "You have already voted");
        require(candidateIndex < candidates.length, "Invalid candidate index");
        
        voter.hasVoted = true;
        candidates[candidateIndex].voteCount++;
        totalVotes++;
        emit Voted(msg.sender, candidateIndex);
    }

    function getNumCandidates() public view returns (uint256) {
        return candidates.length;
    }

    function getCandidate(uint256 index) public view returns (string memory, uint256) {
        require(index < candidates.length, "Invalid candidate index");
        Candidate storage candidate = candidates[index];
        return (candidate.name, candidate.voteCount);
    }
}
