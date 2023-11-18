"""new_initial_migration

Revision ID: 10e5672f8ae5
Revises: 
Create Date: 2023-08-28 20:06:38.095627

"""
from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql

# revision identifiers, used by Alembic.
revision = '10e5672f8ae5'
down_revision = None
branch_labels = None
depends_on = None


def upgrade() -> None:
    # ### commands auto generated by Alembic - please adjust! ###
    op.create_table('job',
    sa.Column('uuid', postgresql.UUID(as_uuid=True), nullable=False),
    sa.Column('title', sa.String(length=255), nullable=True),
    sa.Column('description', sa.Text(), nullable=True),
    sa.Column('responsibilities', sa.Text(), nullable=True),
    sa.Column('qualifications', sa.Text(), nullable=True),
    sa.Column('work_mode', sa.String(length=255), nullable=True),
    sa.Column('createdAt', sa.DateTime(), nullable=True),
    sa.Column('updatedAt', sa.DateTime(), nullable=True),
    sa.PrimaryKeyConstraint('uuid')
    )
    op.create_table('candidate',
    sa.Column('uuid', postgresql.UUID(as_uuid=True), nullable=False),
    sa.Column('name', sa.String(length=255), nullable=True),
    sa.Column('date_of_birth', sa.String(length=255), nullable=True),
    sa.Column('submitted_datetime', sa.DateTime(), nullable=True),
    sa.Column('email', sa.String(length=255), nullable=True),
    sa.Column('phone', sa.String(length=255), nullable=True),
    sa.Column('cv_score', sa.Float(), nullable=True),
    sa.Column('job_uuid', postgresql.UUID(as_uuid=True), nullable=True),
    sa.Column('status', sa.String(length=255), nullable=True),
    sa.Column('interview_feedback', sa.JSON(), nullable=True),
    sa.Column('cv_json', sa.JSON(), nullable=True),
    sa.Column('createdAt', sa.DateTime(), nullable=True),
    sa.Column('updatedAt', sa.DateTime(), nullable=True),
    sa.ForeignKeyConstraint(['job_uuid'], ['job.uuid'], ),
    sa.PrimaryKeyConstraint('uuid'),
    sa.UniqueConstraint('email')
    )
    # ### end Alembic commands ###


def downgrade() -> None:
    # ### commands auto generated by Alembic - please adjust! ###
    op.drop_table('candidate')
    op.drop_table('job')
    # ### end Alembic commands ###
