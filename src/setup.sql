-- ========================================
-- Organization Table
-- ========================================

CREATE TABLE IF NOT EXISTS organization (
    organization_id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    description TEXT NOT NULL,
    contact_email VARCHAR(255) NOT NULL,
    logo_filename VARCHAR(255) NOT NULL
);

-- ========================================
-- Insert Sample Organization Data
-- ========================================

INSERT INTO organization (
    name,
    description,
    contact_email,
    logo_filename
)
SELECT name, description, contact_email, logo_filename
FROM (
VALUES
(
    'BrightFuture Builders',
    'A nonprofit focused on improving community infrastructure through sustainable construction projects.',
    'info@brightfuturebuilders.org',
    'brightfuture-logo.png'
),
(
    'GreenHarvest Growers',
    'An urban farming collective promoting food sustainability and education in local neighborhoods.',
    'contact@greenharvest.org',
    'greenharvest-logo.png'
),
(
    'UnityServe Volunteers',
    'A volunteer coordination group supporting local charities and service initiatives.',
    'hello@unityserve.org',
    'unityserve-logo.png'
)
) AS sample_organizations (
    name,
    description,
    contact_email,
    logo_filename
)
WHERE NOT EXISTS (
    SELECT 1
    FROM organization o
    WHERE o.name = sample_organizations.name
);

-- ========================================
-- Service Project Table
-- ========================================

CREATE TABLE IF NOT EXISTS service_project (
    project_id SERIAL PRIMARY KEY,
    organization_id INTEGER NOT NULL REFERENCES organization(organization_id) ON DELETE CASCADE,
    title VARCHAR(150) NOT NULL,
    description TEXT NOT NULL,
    location VARCHAR(150) NOT NULL,
    project_date DATE NOT NULL,
    CONSTRAINT service_project_organization_title_date_unique
        UNIQUE (organization_id, title, project_date)
);

-- ========================================
-- Insert Sample Service Project Data
-- ========================================

INSERT INTO service_project (
    organization_id,
    title,
    description,
    location,
    project_date
)
SELECT
    o.organization_id,
    sample_projects.title,
    sample_projects.description,
    sample_projects.location,
    sample_projects.project_date
FROM (
    VALUES
    (
        'BrightFuture Builders',
        'Neighborhood Ramp Build',
        'Build wheelchair-accessible ramps for residents who need safer access to their homes.',
        'Riverside Neighborhood',
        DATE '2026-06-06'
    ),
    (
        'BrightFuture Builders',
        'Community Center Painting',
        'Refresh classrooms and meeting rooms with new paint and basic repairs.',
        'Eastside Community Center',
        DATE '2026-06-20'
    ),
    (
        'BrightFuture Builders',
        'School Garden Boxes',
        'Construct raised garden boxes for an elementary school outdoor learning space.',
        'Lincoln Elementary School',
        DATE '2026-07-11'
    ),
    (
        'BrightFuture Builders',
        'Home Repair Day',
        'Assist older residents with small repairs, cleanup, and safety improvements.',
        'Maple Street District',
        DATE '2026-07-25'
    ),
    (
        'BrightFuture Builders',
        'Park Bench Installation',
        'Install benches and improve rest areas along a local walking path.',
        'Riverbend Park',
        DATE '2026-08-08'
    ),
    (
        'GreenHarvest Growers',
        'Urban Farm Planting',
        'Prepare garden beds and plant seasonal vegetables for neighborhood food distribution.',
        'GreenHarvest Urban Farm',
        DATE '2026-06-13'
    ),
    (
        'GreenHarvest Growers',
        'Compost Education Booth',
        'Teach families how to reduce food waste through simple home composting practices.',
        'Downtown Farmers Market',
        DATE '2026-06-27'
    ),
    (
        'GreenHarvest Growers',
        'Food Pantry Harvest',
        'Harvest, wash, and package fresh produce for local food pantry partners.',
        'GreenHarvest Urban Farm',
        DATE '2026-07-18'
    ),
    (
        'GreenHarvest Growers',
        'Pollinator Garden Cleanup',
        'Remove weeds and add native plants to improve habitat for local pollinators.',
        'Cedar Creek Trailhead',
        DATE '2026-08-01'
    ),
    (
        'GreenHarvest Growers',
        'Seedling Workshop',
        'Help children and families start seedlings to grow herbs and vegetables at home.',
        'West Branch Library',
        DATE '2026-08-15'
    ),
    (
        'UnityServe Volunteers',
        'Weekend Food Drive',
        'Collect and sort donated canned goods for families facing food insecurity.',
        'UnityServe Donation Center',
        DATE '2026-06-07'
    ),
    (
        'UnityServe Volunteers',
        'Community Tutoring Night',
        'Support students with homework help, reading practice, and basic math review.',
        'Northside Youth Center',
        DATE '2026-06-18'
    ),
    (
        'UnityServe Volunteers',
        'Health Kit Assembly',
        'Assemble hygiene kits for shelters and outreach programs serving vulnerable residents.',
        'UnityServe Volunteer Hall',
        DATE '2026-07-09'
    ),
    (
        'UnityServe Volunteers',
        'Senior Tech Help',
        'Help older adults set up email, video calls, and basic phone accessibility settings.',
        'Oak Ridge Senior Center',
        DATE '2026-07-23'
    ),
    (
        'UnityServe Volunteers',
        'Back-to-School Supply Sort',
        'Sort backpacks, notebooks, and classroom supplies for students before the school year.',
        'UnityServe Donation Center',
        DATE '2026-08-06'
    )
) AS sample_projects (
    organization_name,
    title,
    description,
    location,
    project_date
)
INNER JOIN organization o
    ON o.name = sample_projects.organization_name
ON CONFLICT (organization_id, title, project_date) DO NOTHING;

-- Verify service project data with organization names.
SELECT
    sp.project_id,
    sp.organization_id,
    sp.title,
    sp.description,
    sp.location,
    sp.project_date,
    o.name AS organization_name
FROM service_project sp
INNER JOIN organization o
    ON sp.organization_id = o.organization_id
ORDER BY sp.project_date, sp.title;
