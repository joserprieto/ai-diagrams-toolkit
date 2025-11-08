# Test Sample 03: AWS Cloud Architecture

Create a Mermaid flowchart diagram showing AWS cloud infrastructure:

**Architecture**: Highly available web application on AWS

**Components**:

**Edge/CDN**:

- CloudFront (CDN)
- Route 53 (DNS)

**Compute Layer**:

- Application Load Balancer
- Auto Scaling Group
- EC2 Instances (web servers)

**Data Layer**:

- RDS PostgreSQL (Multi-AZ)
- ElastiCache Redis (cluster)
- S3 (static assets)

**Security/Network**:

- VPC (Virtual Private Cloud)
- Security Groups
- WAF (Web Application Firewall)

**Monitoring**:

- CloudWatch (metrics and logs)
- SNS (alerts)

**Flow**:

1. User request → Route 53 DNS
2. Route 53 → CloudFront CDN
3. CloudFront → WAF (security check)
4. WAF → Application Load Balancer
5. ALB → EC2 Instances (Auto Scaling Group)
6. EC2 → ElastiCache (check cache)
7. If cache miss → RDS PostgreSQL
8. Static assets → S3
9. Monitoring → CloudWatch → SNS alerts

**Requirements**:

- Use AWS-specific naming (CloudFront, RDS, not CDN1, DB1)
- Subgraphs for layers (Edge, Compute, Data, Security, Monitoring)
- Architectural layer colors
- Show data flow with arrows
- Decision point for cache hit/miss (warning color)

**Diagram type**: Flowchart (graph TD) with AWS architecture
